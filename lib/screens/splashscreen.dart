import 'package:app_and_up/screens/authscreen.dart';
import 'package:app_and_up/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _logincheck = false;

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('loginflag')) {
      _logincheck = true;
      return true;
    } else if (prefs.containsKey('loginflaggmail')) {
      FirebaseAuth.instance.userChanges().listen((User user) {
        if (user == null) {
          print('User is currently signed out!');
          _logincheck = false;
          return false;
        } else {
          print('User is signed in!');
          print(FirebaseAuth.instance.currentUser.displayName);
          _logincheck = true;
          return true;
        }
      });
    }
    _logincheck = false;
    return false;
  }

  void delay() {
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (_logincheck)
        Navigator.pushReplacementNamed(context, Home.routeName);
      else
        Navigator.pushReplacementNamed(context, AuthScreen.routeName);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
    delay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Container(
              height: 1000,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Lottie.asset('assets/images/splash.json',
                  height: 200, width: 200),
            ),
          ),
        ],
      ),
    );
  }
}
