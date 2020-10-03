import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../ui/backTopBar.dart';

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
