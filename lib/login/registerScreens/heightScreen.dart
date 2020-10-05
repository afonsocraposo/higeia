import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../ui/rangeSelector.dart';

class HeightScreen extends StatelessWidget {
  const HeightScreen(
      {@required this.onHeightChanged, @required this.onWeightChanged, Key key})
      : super(key: key);

  final Function onHeightChanged;
  final Function onWeightChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RangeSelector(
          50,
          250,
          initialValue: 170,
          title: "Height",
          unit: "cm",
          onItemSelected: (num value) {
            onHeightChanged(value.toInt());
          },
        ),
        RangeSelector(
          30,
          180,
          initialValue: 60,
          title: "Weight",
          unit: "kg",
          onItemSelected: (num value) {
            onWeightChanged(value.toInt());
          },
        ),
      ],
    );
  }
}
