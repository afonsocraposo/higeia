part of 'fire_functions.dart';

const HAPPINESS_TIMEOUT_IN_MINUTES = 10;

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

  static Future<void> removeLastHappiness() async {
    String docID = (await FireFunctions.getMeasurementsReference()
            .collection("happiness")
            .orderBy("timestamp", descending: true)
            .limit(1)
            .get())
        ?.docs
        ?.first
        ?.id;
    if (docID != null) removeHappiness(docID);
  }

  static CollectionReference getHappinessReference() =>
      FireFunctions.getMeasurementsReference().collection("happiness");

  static Stream<List<Happiness>> getHappinessStream(
      {DateTime start, DateTime end}) {
    Query query = getHappinessReference().orderBy(
      "timestamp",
    );
    if (start != null)
      query = query.where(
        "timestamp",
        isGreaterThanOrEqualTo: Timestamp.fromDate(start.toUtc()),
      );
    if (end != null)
      query = query.where(
        "timestamp",
        isLessThanOrEqualTo: Timestamp.fromDate(end.toUtc()),
      );
    return query.snapshots().map(
          (QuerySnapshot querySnapshot) => List<Happiness>.from(
              querySnapshot.docs.map(
                (QueryDocumentSnapshot snap) => Happiness.fromDocument(snap),
              ),
              growable: false),
        );
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

  static Future<bool> readyNewHappiness() async {
    DateTime lastDateTime = await getLastHappinessDateTime();
    return DateTime.now().difference(lastDateTime).inMinutes >
        HAPPINESS_TIMEOUT_IN_MINUTES;
  }

  static int getTimeout() {
    return HAPPINESS_TIMEOUT_IN_MINUTES;
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

  static Future<void> updateHappiness(Happiness happiness) async {
    await getHappinessReference()
        .doc(happiness.id)
        .update(happiness.toDocument());
  }
}
