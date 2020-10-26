import 'package:flutter/material.dart';

class HeartClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(size.width / 8, 2 * size.height / 3);
    path.arcToPoint(
      Offset(size.width / 2, size.height / 5),
      radius: Radius.circular(size.height / 4),
    );
    path.arcToPoint(
      Offset(7 * size.width / 8, 2 * size.height / 3),
      radius: Radius.circular(size.height / 4),
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

