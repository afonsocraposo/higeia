import 'package:flutter/material.dart';
import 'package:higeia/utils/colors.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    this.text = "",
    this.widget,
    this.textColor = Colors.white,
    this.color = MyColors.mainGreen,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    @required this.onPressed,
    this.borderColor = MyColors.mainGreen,
    this.borderWidth = 0,
    this.elevation = 2,
    Key key,
  }) : super(key: key);

  final String text;
  final Function onPressed;
  final Color textColor;
  final Color color;
  final Widget widget;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets margin;
  final double elevation;

  @override
  Widget build(BuildContext context) => Container(
        margin: this.margin,
        height: 56,
        width: double.infinity,
        child: RaisedButton(
          elevation: this.elevation,
          onPressed: this.onPressed,
          shape: RoundedRectangleBorder(
            side: borderWidth != 0
                ? BorderSide(width: this.borderWidth, color: this.borderColor)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: this.color,
          child: this.widget != null
              ? this.widget
              : Text(
                  this.text,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: this.textColor,
                  ),
                ),
        ),
      );
}
