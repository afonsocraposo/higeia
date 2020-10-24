import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Happiness {
  String id;
  int value;
  DateTime timestamp;

  Happiness(
      {@required this.id, @required this.value, @required this.timestamp});

  Happiness.fromDocument(DocumentSnapshot doc)
      : id = doc.id,
        value = doc.data()["value"],
        timestamp = doc.data()["timestamp"].toDate().toLocal();

  Map<String, dynamic> toDocument() {
    return {"value": value, "timestamp": timestamp.toUtc()};
  }

  Happiness duplicate() =>
      Happiness(id: this.id, value: this.value, timestamp: this.timestamp);
}
