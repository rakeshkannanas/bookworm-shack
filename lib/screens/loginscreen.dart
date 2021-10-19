import 'dart:convert';
import 'dart:io';
import 'package:app_and_up/properties/props.dart';
import 'package:app_and_up/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _emailId, _password;
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  void _snackBar(String textmsg, String actionmsg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(textmsg),
      action: SnackBarAction(
        label: actionmsg,
        onPressed: () {},
      ),
    ));
  }

  Future<void> _loginUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    try {
      setState(() {
        isLoading = true;
      });
      final res = await http.post(Props.logIn,
          body: jsonEncode({
            'email': _emailId.trim(),
            'password': _password.trim(),
            'returnSecureToken': true
          }));
      if (jsonDecode(res.body)['error'] != null) {
        print(jsonDecode(res.body)['error']['message']);
        if (jsonDecode(res.body)['error']['message']
            .toString()
            .contains("INVALID_PASSWORD")) {
          _snackBar('Incorrect Password', 'ok');
        } else if (jsonDecode(res.body)['error']['message']
            .toString()
            .contains("EMAIL_EXISTS")) {
          _snackBar('Email ID already exists', 'ok');
        } else if (jsonDecode(res.body)['error']['message']
            .toString()
            .contains("EMAIL_NOT_FOUND")) {
          _snackBar('Email ID not found', 'ok');
        }
        setState(() {
          isLoading = false;
        });
        return;
      }
      setState(() {
        isLoading = false;
      });
      // token = jsonDecode(res.body)['idToken'];
      // userId = jsonDecode(res.body)['localId'];
      // expiryTime = DateTime.now().add(Duration(seconds: int.parse(jsonDecode(res.body)['expiresIn'])));
      print(jsonDecode(res.body));
      print(jsonDecode(res.body)['idToken']);

      prefs.setString(Props.LOGIN_FLAG, 'Y');
      Navigator.pushReplacementNamed(context, Home.routeName);
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Check Network Connection'),
      ));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/libbg.jpg'),
            fit: BoxFit.cover,
          )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              Spacer(),
              Stack(
                children: [
                  ClipPath(
                    clipper: WaveClipperOne(reverse: true),
                    child: Container(
                      height: mediaQuery.size.height / 2.2,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                        child: Text(
                          'Welcome \nBack',
                          style: TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(labelText: 'Email ID'),
                          onSaved: (value) {
                            _emailId = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your Email ID';
                            } else if (!value.contains("@")) {
                              return 'Enter valid Email';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Password'),
                          onSaved: (value) {
                            _password = value;
                          },
                          //  controller: passController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your password';
                            } else if (value.length < 7) {
                              return 'Password should have minimum of 8 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _loginUser(context);
                          },
                          child: Text(
                            'Log in',
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
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isLoading)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black54,
            child: SpinKitFadingCube(
              color: Colors.white,
              size: 40.0,
            ),
          ),
      ]),
    ));
  }
}
