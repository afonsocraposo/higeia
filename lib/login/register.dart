import 'package:flutter/material.dart';

import 'registerScreens/nameScreen.dart';
import '../ui/myTopBar.dart';
import '../ui/myButton.dart';
import '../utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen(this.userID, {Key key}) : super(key: key);
  final String userID;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  static List<String> _titles = ["Name", "Birthdate"];
  int _currentIndex = 0;
  TabController _tabController;
  static TextEditingController _nameController = TextEditingController();
  List<Widget> _screens = [
    NameScreen(_nameController),
    NameScreen(_nameController),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _titles.length);
    _tabController.animation.addListener(() {
      int newIndex = _tabController.animation.value.round();
      if (_currentIndex != newIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
        print(_currentIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyTopBar(
        title: _titles[_currentIndex],
        onPressed: () {
          //TODO: warning and logout
          Navigator.of(context).popAndPushNamed("/login");
        },
      ),
      body: SafeArea(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: BouncingScrollPhysics(),
                  children: _screens,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _titles.length,
                  (int index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: ClipOval(
                      child: Container(
                          height: 12,
                          width: 12,
                          color:
                              index <= _currentIndex ? mainGreen : Colors.grey),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: MyButton(
                  text: _currentIndex + 1 == _titles.length ? "Done" : "Next",
                  onPressed: () {
                    if (_currentIndex + 1 == _titles.length) {
                      //TODO: done
                    } else {
                      setState(() {
                        _tabController.animateTo(_currentIndex + 1);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
