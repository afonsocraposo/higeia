import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:higeia/values/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';

import 'utils/fire_functions.dart';

const SPLASH_DURATION_IN_SECONDS = 2;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final Completer waiting = Completer<bool>();

  @override
  void initState() {
    super.initState();
    isUserLoggedIn();
  }

  void isUserLoggedIn() async {
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user != null) {
        if (await FireFunctions.userExists(user.uid)) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/home", ModalRoute.withName('/splash'));
        } else {
          if (await FireFunctions.alreadyAcceptedTerms()) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/register", ModalRoute.withName('/splash'));
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/consent", ModalRoute.withName('/splash'));
          }
        }
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/login", ModalRoute.withName('/splash'));
      }
    }, onError: (onError) {
      print(onError);
    }, onDone: () {
      print("onDone");
    });
  }

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainGreen,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Higeia",
                  style: TextStyle(
                    fontSize: 62,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Your smart health assistant",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: min(
                400,
                MediaQuery.of(context).size.width * 0.7,
              ),
              child: SvgPicture.asset(
                "assets/images/undraw_medicine_b1ol.svg",
                width: min(
                  400,
                  MediaQuery.of(context).size.width * 0.7,
                ),
              ),
            ),
            SpinKitPumpingHeart(
              color: Colors.white,
              size: 64,
              duration: Duration(
                seconds: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
