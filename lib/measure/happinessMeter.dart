import 'package:flutter/material.dart';
import 'package:higeia/utils/colors.dart';

import '../utils/fireFunctions.dart';

const MINIMUM_TIME_IN_MINUTES = 60;

class HappinessMeter extends StatefulWidget {
  const HappinessMeter({Key key}) : super(key: key);

  @override
  _HappinessMeterState createState() => _HappinessMeterState();
}

class _HappinessMeterState extends State<HappinessMeter> {
  static const List<String> happinessEmoji = <String>[
    "😭",
    "🙁",
    "😐",
    "🙂",
    "😁",
  ];
  static const List<Color> happinessColor = <Color>[
    Colors.red,
    Colors.orange,
    Colors.yellow,
    MyColors.mainGreen,
    MyColors.mainBlue,
  ];
  static double _happiness = (happinessEmoji.length / 2).ceilToDouble();
  String _previousID;
  Widget _chartButton;

  @override
  void initState() {
    super.initState();
    _chartButton = RawMaterialButton(
      shape: CircleBorder(),
      fillColor: MyColors.mainGreen,
      child: Icon(
        Icons.insert_chart,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).pushNamed("/chart");
      },
    );
  }

  void _setHappiness(double happiness) async {
    String id = await HappinessFunctions.addHappiness(happiness.toInt());
    setState(() {
      _previousID = id;
    });
  }

  void _undoHappiness() async {
    if (_previousID != null) {
      HappinessFunctions.removeHappiness(_previousID);
      _previousID = null;
    } else {
      HappinessFunctions.removeLastHappiness();
    }
    setState(() {
      _happiness = (happinessEmoji.length / 2).ceilToDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 32),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
          future: HappinessFunctions.getLastHappinessDateTime(),
          builder: (BuildContext context, AsyncSnapshot<DateTime> snap) =>
              Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children:
                (-(snap?.data?.difference(DateTime.now())?.inMinutes ?? 0) >
                        MINIMUM_TIME_IN_MINUTES)
                    ? [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  //vertical: 8,
                                  horizontal: 20,
                                ),
                                child: Text("How are you feeling?"),
                              ),
                              _chartButton,
                            ],
                          ),
                        ),
                        Text(
                          happinessEmoji[_happiness.toInt() - 1],
                          style: TextStyle(
                            fontSize: 48,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Slider(
                          onChanged: (double value) =>
                              setState(() => _happiness = value),
                          onChangeEnd: _setHappiness,
                          value: _happiness,
                          min: 1,
                          max: happinessEmoji.length.toDouble(),
                          activeColor: happinessColor[_happiness.toInt() - 1],
                          inactiveColor: MyColors.grey,
                          divisions: happinessEmoji.length - 1,
                          //label: happiness.toStringAsFixed(0),
                        )
                      ]
                    : [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  //vertical: 8,
                                  horizontal: 20,
                                ),
                                child: Text("Saved!"),
                              ),
                              _chartButton,
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.check_circle_outline,
                            color: MyColors.mainGreen,
                            size: 48,
                          ),
                        ),
                        FlatButton(
                          onPressed: _undoHappiness,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.undo,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Undo last",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
          ),
        ),
      ),
    );
  }
}
