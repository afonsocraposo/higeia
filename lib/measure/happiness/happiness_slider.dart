import 'package:flutter/material.dart';
import 'package:higeia/values/colors.dart';
import 'package:higeia/values/strings.dart';

class HappinessSlider extends StatefulWidget {
  const HappinessSlider(this.value, this.onChanged, this.onChangeEnd, {Key key})
      : super(key: key);

  final int value;
  final Function onChanged;
  final Function onChangeEnd;

  @override
  _HappinessSliderState createState() => _HappinessSliderState();
}

class _HappinessSliderState extends State<HappinessSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          HAPPINESS_EMOJIS[widget.value - 1],
          style: TextStyle(
            fontSize: 48,
          ),
          textAlign: TextAlign.center,
        ),
        Slider(
          onChanged: widget.onChanged,
          onChangeEnd: widget.onChangeEnd,
          value: widget.value.toDouble(),
          min: 1,
          max: HAPPINESS_EMOJIS.length.toDouble(),
          activeColor: HAPPINESS_COLORS[widget.value - 1],
          inactiveColor: MyColors.grey,
          divisions: HAPPINESS_EMOJIS.length - 1,
          //label: happiness.toStringAsFixed(0),
        )
      ],
    );
  }
}

