import 'package:flutter/material.dart';
import 'dart:math';

import '../utils/colors.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog(this.title, this.text, {Key key}) : super(key: key);
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    double width = min(0.8 * MediaQuery.of(context).size.width, 400);
    double height = min(0.6 * MediaQuery.of(context).size.height, 500);
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: height,
          minWidth: width,
          maxWidth: width,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                this.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.mainGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Container(
                  child: Text(
                    this.text,
                    //textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
