import 'package:flutter/material.dart';
import 'package:higeia/values/colors.dart';

class OptionDialog extends StatelessWidget {
  const OptionDialog(
      {@required this.title,
      @required this.content,
      @required this.positiveBtnText,
      this.negativeBtnText = "Cancel",
      this.icon = const Icon(
        Icons.warning,
        size: 40,
        color: Colors.white,
      ),
      this.isDestructive = false,
      this.positiveBtnPressed,
      this.negativeBtnPressed,
      Key key})
      : super(key: key);
  final String title;
  final String content;
  final Function positiveBtnPressed;
  final Function negativeBtnPressed;
  final String positiveBtnText;
  final String negativeBtnText;
  final Widget icon;
  final bool isDestructive;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
                ButtonBar(
                  buttonMinWidth: 100,
                  buttonHeight: 50,
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        negativeBtnText,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        if (this.negativeBtnPressed != null)
                          this.negativeBtnPressed();
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        positiveBtnText,
                        style: TextStyle(
                          color: this.isDestructive
                              ? Colors.red
                              : MyColors.mainGreen,
                        ),
                      ),
                      onPressed: () {
                        if (this.positiveBtnPressed != null)
                          this.positiveBtnPressed();
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          CircleAvatar(
            // Top Circle with icon
            backgroundColor: MyColors.mainGreen,
            maxRadius: 40.0,
            child: IconTheme(
                data: IconThemeData(
                  size: 40,
                  color: Colors.white,
                ),
                child: this.icon),
          ),
        ],
      ),
    );
  }
}
