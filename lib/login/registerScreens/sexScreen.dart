import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SexScreen extends StatefulWidget {
  const SexScreen(this.selectSex, {Key key}) : super(key: key);
  final Function selectSex;

  @override
  _SexScreenState createState() => _SexScreenState();
}

class _SexScreenState extends State<SexScreen> {
  bool _isFemale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          alignment: Alignment.center,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select one",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 24, right: 12),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isFemale = (_isFemale == null ? true : null);
                                });
                                widget.selectSex(_isFemale);
                              },
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 6,
                                      color: _isFemale ?? false
                                          ? Colors.orange.withAlpha(150)
                                          : Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) =>
                                        SvgPicture.asset(
                                      "assets/images/undraw_female_avatar_w3jk.svg",
                                      width: constraints.maxWidth,
                                      height: constraints.maxWidth,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text("Female"),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 12, right: 24),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isFemale =
                                      (_isFemale == null ? false : null);
                                });
                                widget.selectSex(_isFemale);
                              },
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 6,
                                      color: !(_isFemale ?? true)
                                          ? Colors.orange.withAlpha(150)
                                          : Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) =>
                                        SvgPicture.asset(
                                      "assets/images/undraw_male_avatar_323b.svg",
                                      width: constraints.maxWidth,
                                      height: constraints.maxWidth,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text("Male"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
