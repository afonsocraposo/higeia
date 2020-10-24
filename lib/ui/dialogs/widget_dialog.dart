import 'package:flutter/material.dart';
import 'package:higeia/values/colors.dart';

class WidgetDialog extends StatelessWidget {
  WidgetDialog({@required this.child, this.icon, Key key}) : super(key: key);

  final Widget child;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            // Bottom rectangular box
            margin: EdgeInsets.only(
                top: 40), // to push the box half way below circle
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.only(
                top: 60, left: 20, right: 20), // spacing inside the box
            child: this.child,
          ),
          Positioned(
            top: 50,
            right: 10,
            child: IconButton(
              icon: Icon(
                Icons.close,
              ),
              color: Colors.grey,
              onPressed: () {
                Navigator.of(context).pop("Dismiss");
              },
            ),
          ),
          this.icon != null
              ? CircleAvatar(
                  // Top Circle with icon
                  backgroundColor: MyColors.mainGreen,
                  maxRadius: 40.0,
                  child: IconTheme(
                      data: IconThemeData(
                        size: 40,
                        color: Colors.white,
                      ),
                      child: this.icon),
                )
              : Container(width: 0, height: 0),
        ],
      ),
    );
  }
}
