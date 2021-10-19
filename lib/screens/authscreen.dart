import 'package:app_and_up/properties/props.dart';
import 'package:app_and_up/provider/google_sign_in.dart';
import 'package:app_and_up/screens/home.dart';
import 'package:app_and_up/screens/loginscreen.dart';
import 'package:app_and_up/screens/signupscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = 'AuthScreen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void _snackBar(String textmsg, String actionmsg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(textmsg),
      action: SnackBarAction(
        label: actionmsg,
        onPressed: () {},
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/libbg.jpg'),
              fit: BoxFit.cover,
            )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: (mediaQuery.size.height -
                  mediaQuery.padding.top) /
                  2,
              width: mediaQuery.size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                color: const Color(0xFF0E3311).withOpacity(0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Text(
                          'The Bookworm Shack',
                          style: TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                        child: Text(
                          'If you are a bookworm, student, or a person who likes to read books online, then The Bookworm Shack App is an ideal destination for you.',
                          style: TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          child: Text(
                            'Log in',
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              minimumSize: Size(
                                  mediaQuery.size.width - 40,
                                  40) // put the width and height you want
                              ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SignupScreen.routeName);
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              minimumSize: Size(
                                  mediaQuery.size.width - 40,
                                  40) // put the width and height you want
                              ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Divider(
                              color: Colors.white,
                            ),
                          )),
                          Text(
                            "OR",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Divider(
                              color: Colors.white,
                            ),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            await provider.googleLogin();
                            FirebaseAuth.instance
                                .userChanges()
                                .listen((User user) async {
                              if (user == null) {
                                print('User is currently signed out!');
                                _snackBar('Google Sign up failed !', 'ok');
                              } else {
                                print('User is signed in!');
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(Props.UID,
                                    FirebaseAuth.instance.currentUser.uid);
                                prefs.setString(Props.LOGIN_FLAG_GMAIL, 'Y');
                                print(prefs.getString('loginflaggmail'));
                                _snackBar(
                                    FirebaseAuth
                                            .instance.currentUser.displayName +
                                        ' signed in !',
                                    'ok');
                                Navigator.pushReplacementNamed(
                                    context, Home.routeName);
                              }
                            });
                          },
                          icon: FaIcon(FontAwesomeIcons.googlePlusG),
                          label: Text(
                            'SIGN IN WITH GMAIL',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              minimumSize: Size(
                                  mediaQuery.size.width - 40,
                                  40) // put the width and height you want
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
