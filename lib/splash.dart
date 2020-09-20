import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200))
        .then((value) => isUserLoggedIn());
  }

  void isUserLoggedIn() async {
    User user = FirebaseAuth.instance.currentUser;
    if (user != null)
      Navigator.of(context).pushReplacementNamed("/home");
    else
      Navigator.of(context).pushReplacementNamed("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("Splash"),
        ),
      ),
    );
  }
}
