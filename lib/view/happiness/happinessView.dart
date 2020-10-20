import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../../data/happiness.dart';
import '../../utils/fireFunctions.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../../ui/colorTopBar.dart';
import '../../ui/timeSeries.dart';

const LOAD_DAYS = 30;
const List<String> HAPPINESS_EMOJI = <String>[
  "😭",
  "🙁",
  "😐",
  "🙂",
  "😁",
];
const List<Color> HAPPINESS_COLORS = <Color>[
  Colors.red,
  Colors.orange,
  Colors.yellow,
  MyColors.mainGreen,
  MyColors.mainBlue,
];

class HappinessView extends StatefulWidget {
  const HappinessView({Key key}) : super(key: key);

  @override
  _HappinessViewState createState() => _HappinessViewState();
}

class _HappinessViewState extends State<HappinessView> {
  static DateTime end = DateTime.now();
  static DateTime start = end.subtract(
    Duration(days: LOAD_DAYS),
  );
  int _selectedIndex;
  List<DateValue> _happinessValues = [];
  StreamSubscription _stream;

  @override
  void initState() {
    super.initState();
    _startSteam();
  }

  _startSteam() {
    _stream = HappinessFunctions.getHappinessStream(start: start)
        .listen((List<Happiness> happinessValues) {
      if (happinessValues != null && happinessValues.isNotEmpty) {
        setState(() {
          _happinessValues = happinessValues
              .map((Happiness happiness) =>
                  DateValue(happiness.timestamp, happiness.value))
              .toList(growable: false);
        });
      }
    });
  }

  @override
  void dispose() {
    _stream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == null && _happinessValues.length > 1)
      _selectedIndex = _happinessValues.length - 1;
    return Scaffold(
      appBar: ColorTopBar(),
      body: SafeArea(
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClipperOne(),
              child: Container(
                color: MyColors.mainGreen,
                height: 150,
              ),
            ),
            ListView(
              children: [
                SizedBox(
                  height: 300,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.all(24),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: TimeSeries(
                        _happinessValues,
                        ticks: [1, 2, 3, 4, 5],
                        labels: HAPPINESS_EMOJI,
                        colorTicks: [0.5, 1.5, 2.5, 3.5, 4.5, 5.5],
                        lineColor: Colors.black,
                        grid: false,
                        markerRadius: 8,
                        selectedIndex:
                            _happinessValues.isNotEmpty ? _selectedIndex : null,
                        backgroundColors: HAPPINESS_COLORS
                            .map((Color color) => color.withOpacity(0.2))
                            .toList(growable: false),
                        onSelectionChanged: (int index) =>
                            setState(() => _selectedIndex = index),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          setState(() {
                            _selectedIndex--;
                            if (_selectedIndex <= 0) _selectedIndex = 0;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        _happinessValues.isNotEmpty
                            ? Utils.formatDateTime(
                                _happinessValues[_selectedIndex].timestamp)
                            : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          setState(() {
                            _selectedIndex++;
                            if (_selectedIndex >= _happinessValues.length)
                              _selectedIndex = _happinessValues.length - 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                _happinessValues.isNotEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Text(
                                "I was feeling...",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            HAPPINESS_EMOJI[
                                _happinessValues[_selectedIndex].value - 1],
                            style: TextStyle(fontSize: 40),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
