import 'package:flutter/material.dart';
import 'package:higeia/ui/topbars/back_top_bar.dart';

class About extends StatefulWidget {
  const About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool _activateBack = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100)).then((onValue) {
      setState(() {
        _activateBack = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Text("Write about the app"),
            ),
          ),
          BackTopBar(title: "About", active: _activateBack),
        ],
      ),
    );
  }
}
