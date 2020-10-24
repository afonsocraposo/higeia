import 'package:flutter/material.dart';
import 'package:higeia/values/colors.dart';

class InfoDialog extends StatelessWidget {
  InfoDialog(
      {@required this.title,
      @required this.content,
      this.icon = const Icon(Icons.info, color: Colors.white, size: 40),
      Key key})
      : super(key: key);

  final String title;
  final String content;
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
                SizedBox(
                  height: 16,
                ),
              ],
            ),
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
