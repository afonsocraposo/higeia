import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:higeia/utils/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';

import 'utils/fireFunctions.dart';

//const SPLASH_DURATION_IN_SECONDS = 2;
const SPLASH_DURATION_IN_SECONDS = 0;

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
    Timer(
      Duration(seconds: SPLASH_DURATION_IN_SECONDS),
      () => waiting.complete(false),
    );
  }

  void isUserLoggedIn() async {
    User user = FirebaseAuth.instance.currentUser;
    await waiting.future;
    if (user != null) {
      if (await FireFunctions.userExists(user.uid)) {
        Navigator.of(context).pushReplacementNamed("/home");
      } else {
        if (await FireFunctions.alreadyAcceptedTerms()) {
          Navigator.of(context).pushReplacementNamed("/register");
        } else {
          Navigator.of(context).pushReplacementNamed("/consent");
        }
      }
    } else {
      Navigator.of(context).pushReplacementNamed("/login");
    }
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
