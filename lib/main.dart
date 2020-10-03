import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'splash.dart';
import 'homepage.dart';
import 'login/login.dart';
import 'login/about.dart';
import 'utils/colors.dart';
import 'login/register.dart';
import 'login/consentScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Higeia',
      theme: ThemeData(
        primarySwatch: greenSwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: mainGreen,
        accentColor: Colors.white,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.accent,
          buttonColor: mainGreen,
        ),
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
        primaryIconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(color: mainGreen, centerTitle: true),
        scaffoldBackgroundColor: Colors.white,
        buttonColor: mainGreen,
        hintColor: mainGreen,
        fontFamily: "Montserrat",
      ),
      //home: SplashScreen(),
      home: RegisterScreen("xsKaPbgqKGRG1IrZ9U3QLWbmvmj1"),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/home': (BuildContext context) => HomePage(),
        '/about': (BuildContext context) => About(),
      },
    );
  }
}
