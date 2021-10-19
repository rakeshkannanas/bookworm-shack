import 'dart:convert';
import 'dart:io';
import 'package:app_and_up/properties/props.dart';
import 'package:app_and_up/screens/loginscreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = 'SignupScreen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _emailId, _password, _confirmPassword;
  final _formKey = GlobalKey<FormState>();
  final passController = TextEditingController();
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

  Future<void> _registerUser(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    try {
      setState(() {
        isLoading = true;
      });
      final res = await http.post(Props.signUp,
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
          _snackBar('Invalid Password', 'ok');
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
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(Props.UID, _emailId);
      setState(() {
        isLoading = false;
      });
      print(jsonDecode(res.body));
      print(jsonDecode(res.body)['idToken']);
      Navigator.pushNamed(context, LoginScreen.routeName);
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Check Network Connection'),
      ));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      height: MediaQuery.of(context).size.height / 2,
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
                          'Create \nAccount',
                          style: TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                          controller: passController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your password';
                            } else if (value.length < 8) {
                              return 'Password should have minimum of 8 characters';
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
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                          onSaved: (value) {
                            _confirmPassword = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Confirm password field is empty';
                            } else if (value != passController.text) {
                              return 'Passwords does not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _registerUser(context);
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
                                  MediaQuery.of(context).size.width - 40,
                                  40) // put the width and height you want
                              ),
                        ),
                      ),
                    ],
                  )
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
            child: SpinKitFadingFour(
              color: Colors.white,
              size: 40.0,
            ),
          ),
      ]),
    ));
  }
}
