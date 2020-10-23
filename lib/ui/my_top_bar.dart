import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../utils/colors.dart';

class MyTopBar extends StatelessWidget implements PreferredSizeWidget {
  MyTopBar({@required this.title, @required this.onPressed, Key key})
      : super(key: key);

  final String title;
  final Function onPressed;

  @override
  Size get preferredSize => Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        this.title,
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: this.onPressed,
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
      ),
      flexibleSpace: ClipPath(
        clipper: WaveClipperOne(),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: 30,
          ),
          color: MyColors.mainGreen,
          height: double.infinity,
        ),
      ),
    );
  }
}
