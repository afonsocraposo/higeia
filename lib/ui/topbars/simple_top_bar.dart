import 'package:flutter/material.dart';

class SimpleTopBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleTopBar({@required this.title, this.onPressed, Key key})
      : super(key: key);

  final String title;
  final Function onPressed;

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: this.onPressed != null
          ? IconButton(
              onPressed: onPressed,
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
            )
          : null,
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
    );
  }
}
