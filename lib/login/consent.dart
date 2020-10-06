import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../ui/myButton.dart';
import '../ui/myTopBar.dart';
import '../ui/optionDialog.dart';
import '../utils/colors.dart';
import '../utils/fire.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({Key key}) : super(key: key);

  @override
  _ConsentScreenState createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _ready = false;
  final OptionDialog _leaveDialog = OptionDialog(
    title: "Leave?",
    content: "If you leave now, you'll be logged out.",
    positiveBtnText: "Leave",
    isDestructive: true,
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.offset + 32 >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange) {
          setState(() {
            _ready = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyTopBar(
          title: "Terms & Conditions",
          onPressed: () async {
            bool pop = await showGeneralDialog(
              barrierDismissible: true,
              barrierLabel: "Dismiss",
              context: context,
              barrierColor: Colors.black54, // space around dialog
              transitionDuration: Duration(milliseconds: 250),
              transitionBuilder: (context, a1, a2, child) {
                return ScaleTransition(
                  scale: CurvedAnimation(
                      parent: a1,
                      curve: Curves.fastOutSlowIn,
                      reverseCurve: Curves.fastOutSlowIn),
                  child: _leaveDialog,
                );
              },
              pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) {
                return null;
              },
            );
            if (pop ?? false) {
              await Fire.logout();
              Navigator.of(context).popAndPushNamed("/login");
            }
          }),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                children: [
                  SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                "Before using this application and all its features, you must first read all the "),
                        TextSpan(
                          text: "Terms and Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " as well as the "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text:
                                ". After accepting these terms, you may proceed on using the application."),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: SvgPicture.asset(
                      "assets/images/undraw_Terms_re_6ak4.svg",
                      width: 200,
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                "Before using this application and all its features, you must first read all the "),
                        TextSpan(
                          text: "Terms and Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " as well as the "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text:
                                ". After accepting these terms, you may proceed on using the application."),
                        TextSpan(
                            text:
                                "Before using this application and all its features, you must first read all the "),
                        TextSpan(
                          text: "Terms and Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " as well as the "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text:
                                ". After accepting these terms, you may proceed on using the application."),
                        TextSpan(
                            text:
                                "Before using this application and all its features, you must first read all the "),
                        TextSpan(
                          text: "Terms and Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " as well as the "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text:
                                ". After accepting these terms, you may proceed on using the application."),
                        TextSpan(
                            text:
                                "Before using this application and all its features, you must first read all the "),
                        TextSpan(
                          text: "Terms and Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " as well as the "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text:
                                ". After accepting these terms, you may proceed on using the application."),
                        TextSpan(
                            text:
                                "Before using this application and all its features, you must first read all the "),
                        TextSpan(
                          text: "Terms and Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " as well as the "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text:
                                ". After accepting these terms, you may proceed on using the application."),
                        TextSpan(
                            text:
                                "Before using this application and all its features, you must first read all the "),
                        TextSpan(
                          text: "Terms and Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " as well as the "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text:
                                ". After accepting these terms, you may proceed on using the application."),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: MyButton(
                onPressed: () {
                  Fire.acceptTerms();
                  Navigator.of(context).pushReplacementNamed("/register");
                },
                color: _ready ? MyColors.mainGreen : MyColors.grey,
                text: "Accept",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
