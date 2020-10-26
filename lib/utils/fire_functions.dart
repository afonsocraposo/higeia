import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:higeia/data/happiness.dart';
import 'package:firebase_storage/firebase_storage.dart';

part 'happiness_functions.dart';
part 'ppg_functions.dart';

class FireFunctions {
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

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static DocumentReference getMeasurementsReference() =>
      FirebaseFirestore.instance.collection("measurements").doc(getUserID());

  static Future<bool> uploadFile(File file, String path) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("${getUserID()}/$path");

    final StorageUploadTask uploadTask = storageReference.putFile(file);

    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.

      // Here, every StorageTaskEvent concerning the upload is printed to the logs.
      print('EVENT ${event.type}');
    });

    // Cancel your subscription when done.
    await uploadTask.onComplete;
    streamSubscription?.cancel();
    return uploadTask.isSuccessful;
  }
}
