import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:higeia/data/date_value.dart';
import 'package:higeia/data/happiness.dart';
import 'package:higeia/measure/happiness/happiness_meter.dart';
import 'package:higeia/measure/happiness/happiness_slider.dart';
import 'package:higeia/ui/charts/time_series.dart';
import 'package:higeia/ui/dialogs/info_dialog.dart';
import 'package:higeia/ui/inputs/my_button.dart';
import 'package:higeia/ui/dialogs/widget_dialog.dart';
import 'package:higeia/ui/topbars/color_top_bar.dart';
import 'package:higeia/ui/topbars/simple_top_bar.dart';
import 'package:higeia/utils/fire_functions.dart';
import 'package:higeia/utils/utils.dart';
import 'package:higeia/values/animations.dart';
import 'package:higeia/values/colors.dart';
import 'package:higeia/values/strings.dart';

part 'happiness_detailed.dart';

const LOAD_DAYS = 30;

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

  List<Happiness> _happinessValues = [];
  List<DateValue> _happinessDateValue = [];
  StreamSubscription _stream;
  bool _addingValue = false;

  final timeoutDialog = InfoDialog(
      title: "Not so fast!",
      content:
          "You need to wait at least ${HappinessFunctions.getTimeout()} minutes before your next submission.\nYou can edit your last submission.");

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
          _happinessValues = happinessValues;
          _happinessDateValue = happinessValues
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

  void _addHappiness() async {
    if (await HappinessFunctions.readyNewHappiness()) {
      _addingValue = true;
      await showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: "Dismiss",
        context: context,
        barrierColor: Colors.black54, // space around dialog
        transitionDuration: SHORT_ANIMATION,
        transitionBuilder: (context, a1, a2, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: ANIMATION_CURVE,
                reverseCurve: ANIMATION_CURVE),
            child: WidgetDialog(
              child: SizedBox(
                height: 200,
                child: HappinessMeter(
                  chartButton: false,
                ),
              ),
            ),
          );
        },
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return null;
        },
      );
      _addingValue = false;
    } else {
      showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: "Dismiss",
        context: context,
        barrierColor: Colors.black54, // space around dialog
        transitionDuration: SHORT_ANIMATION,
        transitionBuilder: (context, a1, a2, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: ANIMATION_CURVE,
                reverseCurve: ANIMATION_CURVE),
            child: timeoutDialog,
          );
        },
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return null;
        },
      );
    }
  }

  Widget _happinessSelector() => Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  if (_selectedIndex > 0) {
                    setState(() {
                      _selectedIndex--;
                    });
                  }
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                _happinessDateValue.isNotEmpty
                    ? Utils.formatDateTime(
                        _happinessDateValue[_selectedIndex].timestamp)
                    : "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  if (_selectedIndex < _happinessDateValue.length - 1) {
                    setState(() {
                      _selectedIndex++;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (((_selectedIndex == null || _addingValue) &&
            _happinessDateValue.length > 1) ||
        (_selectedIndex ?? -1) >= _happinessDateValue.length) {
      _selectedIndex = _happinessDateValue.length - 1;
    }
    return Scaffold(
      appBar: SimpleTopBar(
          title: "Happiness", onPressed: () => Navigator.of(context).pop()),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  expandedHeight: 300.0,
                  floating: false,
                  pinned: true,
                  collapsedHeight: 180,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) => Stack(
                      children: [
                        Container(
                          height: constraints.maxHeight,
                          color: Colors.white,
                        ),
                        ClipPath(
                          clipper: OvalBottomBorderClipper(),
                          child: Container(
                            color: MyColors.mainGreen,
                            height: 150,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: TimeSeries(
                                _happinessDateValue,
                                ticks: [1, 2, 3, 4, 5],
                                labels: HAPPINESS_EMOJIS,
                                colorTicks: [0.5, 1.5, 2.5, 3.5, 4.5, 5.5],
                                lineColor: Colors.black,
                                grid: false,
                                markerRadius: 8,
                                selectedIndex: _happinessDateValue.isNotEmpty
                                    ? _selectedIndex
                                    : null,
                                backgroundColors: HAPPINESS_COLORS
                                    .map(
                                        (Color color) => color.withOpacity(0.2))
                                    .toList(growable: false),
                                onSelectionChanged: (int index) =>
                                    setState(() => _selectedIndex = index),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    _happinessSelector(),
                    48,
                  ),
                  pinned: true,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _happinessValues.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: HappinessDetailed(
                                _happinessValues[_selectedIndex],
                              ),
                            )
                          : Container()
                    ],
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: MyButton(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                text: "How are you feeling?",
                onPressed: _addHappiness,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this.child, this.height);

  final Widget child;
  final double height;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox(
      height: height,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
