part of 'fireFunctions.dart';

class HappinessFunctions {
  static Future<String> addHappiness(int value) async {
    DocumentReference docRef =
        FireFunctions.getMeasurementsReference().collection("happiness").doc();
    await docRef
        .set({"timestamp": FieldValue.serverTimestamp(), "value": value});
    return docRef.id;
  }

  static Future<void> removeHappiness(String docID) async {
    return await FireFunctions.getMeasurementsReference()
        .collection("happiness")
        .doc(docID)
        .delete();
  }

  static CollectionReference getHappinessReference() =>
      FireFunctions.getMeasurementsReference().collection("happiness");

  static Stream<QuerySnapshot> getHappinessStream(
      {@required DateTime start, @required DateTime end}) {
    return getHappinessReference()
        .orderBy(
          "timestamp",
          descending: true,
        )
        .where(
          "timestamp",
          isGreaterThanOrEqualTo: Timestamp.fromDate(start.toUtc()),
        )
        .where(
          "timestamp",
          isLessThanOrEqualTo: Timestamp.fromDate(end.toUtc()),
        )
        .snapshots();
  }

  static Future<DateTime> getFirstHappinessDateTime() async {
    return (await getHappinessReference()
            .orderBy("timestamp")
            .limit(1)
            .snapshots()
            .first)
        .docs
        .first
        .data()["timestamp"]
        .toDate()
        .toLocal();
  }

  static Future<DateTime> getLastHappinessDateTime() async {
    return (await getHappinessReference()
            .orderBy("timestamp")
            .limitToLast(1)
            .snapshots()
            .first)
        .docs
        .first
        .data()["timestamp"]
        .toDate()
        .toLocal();
  }
}
