import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/happiness.dart';
import '../../utils/fireFunctions.dart';
import '../../utils/colors.dart';
import '../../ui/timeSeriesDayBar.dart';

const LOAD_WEEKS = 2;
const List<String> HAPPINESS_EMOJI = <String>[
  "😁",
  "🙂",
  "😐",
  "🙁",
  "😭",
  "",
];
const List<Color> HAPPINESS_COLORS = <Color>[
  Colors.white,
  Colors.red,
  Colors.orange,
  Colors.yellow,
  MyColors.mainBlue,
  MyColors.mainGreen
];

class HappinessView extends StatefulWidget {
  const HappinessView({Key key}) : super(key: key);

  @override
  _HappinessViewState createState() => _HappinessViewState();
}

class _HappinessViewState extends State<HappinessView> {
  DateTime start;
  DateTime end;
  DateTime firstDateTime;
  DateTime lastDateTime;
  int _loadWeeks;
  List<Widget> _ticks;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    end = DateTime(now.year, now.month, now.day);
    start = end.subtract(Duration(days: 7 * LOAD_WEEKS - 1));
    _loadWeeks = LOAD_WEEKS;
    HappinessFunctions.getFirstHappinessDateTime().then((value) {
      firstDateTime = value;
      int period = end.difference(firstDateTime).inDays;
      if (period <= LOAD_WEEKS * 7) {
        _loadWeeks = period ~/ 7 + 1;
        start = end.subtract(Duration(days: 7 * _loadWeeks - 1));
      }
      if (firstDateTime.isAfter(start)) firstDateTime = start;
    });

    lastDateTime = end;
    _ticks = List.generate(
      HAPPINESS_EMOJI.length,
      (int index) => Text(
        HAPPINESS_EMOJI[index],
        style: TextStyle(fontSize: 24),
      ),
      growable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: 400,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: StreamBuilder(
                stream: HappinessFunctions.getHappinessStream(
                  start: start,
                  end: end,
                ),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot == null || snapshot.hasError) {
                    return Text("error");
                  } else {
                    if (!snapshot.hasData || snapshot.data.size == 0) {
                      return Text("empty");
                    } else {
                      List<DateValue> happinessValues = snapshot
                          .data.docs.reversed
                          .map((QueryDocumentSnapshot doc) {
                        Happiness happiness = Happiness.fromDocument(doc);
                        return DateValue(
                          happiness.timestamp,
                          happiness.value,
                        );
                      }).toList(growable: false);
                      return TimeSeriesBar(
                        happinessValues,
                        start: start,
                        end: end,
                        loadWeeks: _loadWeeks,
                        ticks: _ticks,
                        colors: HAPPINESS_COLORS,
                        onSelectionChanged: (DateTime dateTime) {
                          print(dateTime);
                        },
                        onStartReached: () {
                          setState(() {
                            start = start.subtract(
                              Duration(
                                days: _loadWeeks - 1,
                              ),
                            );
                            if (start.isBefore(firstDateTime))
                              start = firstDateTime;
                            end = start.add(
                              Duration(
                                days: 7 * _loadWeeks - 1,
                              ),
                            );
                          });
                        },
                        onEndReached: () {
                          setState(() {
                            end = end.add(
                              Duration(
                                days: _loadWeeks - 1,
                              ),
                            );
                            if (end.isAfter(lastDateTime)) end = lastDateTime;
                            start = end.subtract(
                              Duration(
                                days: 7 * _loadWeeks - 1,
                              ),
                            );
                          });
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
