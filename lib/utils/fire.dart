import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Fire {
  static String getUserID() {
    try {
      return FirebaseAuth.instance.currentUser.uid;
    } on NoSuchMethodError {
      throw (FirebaseAuthException(
        message: "No user logged in",
      ));
    } catch (Exception) {
      throw (Exception);
    }
  }

  static Future<void> acceptTerms() async {
    return await FirebaseFirestore.instance
        .collection("consent")
        .doc(getUserID())
        .set(
      {
        "timestamp": FieldValue.serverTimestamp(),
      },
    );
  }

  static Future<bool> alreadyAcceptedTerms() async {
    return await FirebaseFirestore.instance
        .collection("consent")
        .doc(getUserID())
        .get()
        .then((snapshot) => snapshot.exists);
  }

  static Future<void> newUser(
      {@required String name,
      @required birthdate,
      sex,
      @required height,
      @required weight}) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(getUserID())
        .set(
      {
        "name": name,
        "birthdate": birthdate,
        "sex": sex,
        "height": height,
        "weight": weight,
      },
    );
  }

  static Future<bool> userExists(String userID) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .get()
        .then((snapshot) => snapshot.exists);
  }
}
