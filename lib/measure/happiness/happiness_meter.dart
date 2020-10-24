import 'package:flutter/material.dart';
import 'package:higeia/measure/happiness/happiness_slider.dart';
import 'package:higeia/utils/fire_functions.dart';
import 'package:higeia/values/colors.dart';
import 'package:higeia/values/strings.dart';

class HappinessMeter extends StatefulWidget {
  const HappinessMeter({this.chartButton = true, Key key}) : super(key: key);

  final bool chartButton;

  @override
  _HappinessMeterState createState() => _HappinessMeterState();
}

class _HappinessMeterState extends State<HappinessMeter> {
  double _happiness = (HAPPINESS_EMOJIS.length / 2).ceilToDouble();
  String _previousID;
  Widget _chartButton;

  @override
  void initState() {
    super.initState();
    if (widget.chartButton)
      _chartButton = RawMaterialButton(
        shape: CircleBorder(),
        fillColor: MyColors.mainGreen,
        child: Icon(
          Icons.insert_chart,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed("/happiness");
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
      _happiness = (HAPPINESS_EMOJIS.length / 2).ceilToDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: FutureBuilder(
        future: HappinessFunctions.readyNewHappiness(),
        builder: (BuildContext context, AsyncSnapshot<bool> snap) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: snap?.data ?? false
              ? [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 20,
                            ),
                            child: Text("How are you feeling?"),
                          ),
                        ),
                        _chartButton ?? Container(),
                      ],
                    ),
                  ),
                  HappinessSlider(
                      _happiness.toInt(),
                      (double value) => setState(() => _happiness = value),
                      _setHappiness),
                ]
              : [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 20,
                          ),
                          child: Text("Saved!"),
                        ),
                        _chartButton ?? Container(),
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
    );
  }
}
