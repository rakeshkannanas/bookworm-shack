import 'package:app_and_up/provider/books_api_provider.dart';
import 'package:app_and_up/provider/google_sign_in.dart';
import 'package:app_and_up/screens/authscreen.dart';
import 'package:app_and_up/screens/detailsscreen.dart';
import 'package:app_and_up/screens/favoritescreen.dart';
import 'package:app_and_up/screens/home.dart';
import 'package:app_and_up/screens/loginscreen.dart';
import 'package:app_and_up/screens/signupscreen.dart';
import 'package:app_and_up/screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => BooksApiProvider(),
        )
      ],
      child: MaterialApp(
        title: 'The Bookworm Shack',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          AuthScreen.routeName: (context) => AuthScreen(),
          Home.routeName: (context) => Home(),
          LoginScreen.routeName: (context) => LoginScreen(),
          SignupScreen.routeName: (context) => SignupScreen(),
          DetailsScreen.routeName: (context) => DetailsScreen(),
          FavoriteScreen.routeName: (context) => FavoriteScreen(),
        },
      ),
    );
  }
}
