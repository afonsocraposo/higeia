import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:higeia/measure/happiness/happiness_meter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              HappinessMeter(),
              RaisedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  //Navigator.of(context).pushReplacementNamed("/login");
                },
                child: Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
