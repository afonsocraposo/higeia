import 'package:flutter/material.dart';

class ColorTopBar extends StatelessWidget implements PreferredSizeWidget {
  const ColorTopBar({Key key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(0.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(elevation: 0);
  }
}
