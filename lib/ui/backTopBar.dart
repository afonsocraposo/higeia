import 'package:flutter/material.dart';
import '../utils/colors.dart';

class BackTopBar extends StatelessWidget {
  const BackTopBar(
      {@required this.title, this.active = true, this.onPressed, Key key})
      : super(key: key);
  final String title;
  final bool active;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ClipPath(
        clipper: BackTopBarClipper(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          width: active ? 220 : 0,
          height: active ? 170 : 0,
          color: MyColors.mainGreen,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: true,
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (onPressed != null)
                            onPressed();
                          else
                            Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                      Text(
                        "Back",
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    this.title,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 56),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BackTopBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0.0);
    path.arcToPoint(
      Offset(0, 0.8 * size.height),
      radius: Radius.circular(size.width * 0.8),
    );
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(BackTopBarClipper oldClipper) => true;
}

