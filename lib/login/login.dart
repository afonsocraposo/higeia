import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void login() {
    print("test");
    auth.verifyPhoneNumber(
      phoneNumber: '+351926847938',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);
        print(credential.smsCode);
        Navigator.of(context).pushReplacementNamed("/home");
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationId, int resendToken) {
        print("Code sent");
        print(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("Auto retrieval");
        print(verificationId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: RaisedButton(
            onPressed: () {
              login();
            },
            child: Text("login"),
          ),
        ),
      ),
    );
  }
}
