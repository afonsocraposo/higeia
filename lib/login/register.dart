import 'package:flutter/material.dart';

import 'registerScreens/nameScreen.dart';
import 'registerScreens/birthScreen.dart';
import 'registerScreens/sexScreen.dart';
import 'registerScreens/heightScreen.dart';

import '../ui/myTopBar.dart';
import '../ui/myButton.dart';
import '../utils/colors.dart';
import '../utils/fire.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  static const _titles = ["Name", "Birthdate", "Sex", "Height & Weight"];
  List<Widget> _screens;
  int _currentIndex = 0;
  TabController _tabController;

  String _name = "";
  DateTime _birthDate;
  bool _isFemale;
  int _height = 170;
  int _weight = 60;

  void updateName(String name) {
    setState(() {
      _name = name;
    });
  }

  void updateDate(DateTime date) {
    setState(() {
      _birthDate = date;
    });
  }

  void updateSex(bool isFemale) {
    setState(() {
      _isFemale = isFemale;
    });
  }

  void updateHeight(int height) {
    _height = height;
  }

  void updateWeight(int weight) {
    _weight = weight;
  }

  void _onNextPressed() {
    if (_currentIndex == 0) {
      if (_name.isNotEmpty) _tabController.animateTo(_currentIndex + 1);
    } else if (_currentIndex == 1) {
      if (_birthDate != null) _tabController.animateTo(_currentIndex + 1);
    } else if (_currentIndex == 2) {
      if (_isFemale != null) _tabController.animateTo(_currentIndex + 1);
    } else if (_currentIndex == _titles.length - 1) {
      if (_name.isNotEmpty && _birthDate != null)
        Fire.newUser(
                name: _name,
                birthdate: _birthDate,
                sex: _isFemale ? "F" : "M",
                height: _height,
                weight: _weight)
            .then(
          (_) => Navigator.of(context).pushReplacementNamed("/home"),
        );
    } else {
      _tabController.animateTo(_currentIndex + 1);
    }
  }

  Future<bool> _willPopCallback() async {
    FocusScope.of(context).unfocus();
    if (_currentIndex > 0) {
      setState(() {
        _tabController.animateTo(_currentIndex - 1);
      });
      return false;
    } else {
      return true;
    }
  }

  String _buttonText() {
    if (_currentIndex == _titles.length - 1) {
      return "Done";
    } else if (_currentIndex == 2) {
      if (_isFemale == null)
        return "Skip";
      else
        return "Next";
    } else {
      return "Next";
    }
  }

  Color _buttonColor() {
    if (_currentIndex == 0) {
      if (_name.isNotEmpty)
        return MyColors.mainGreen;
      else
        return MyColors.grey;
    } else if (_currentIndex == 1) {
      if (_birthDate != null)
        return MyColors.mainGreen;
      else
        return MyColors.grey;
    } else if (_currentIndex == 2) {
      if (_isFemale != null)
        return MyColors.mainGreen;
      else
        return MyColors.grey;
    } else if (_currentIndex == _titles.length - 1) {
      if (_name.isNotEmpty && _birthDate != null)
        return MyColors.mainGreen;
      else
        return MyColors.grey;
    } else {
      return MyColors.mainGreen;
    }
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      NameScreen(
        updateName,
      ),
      BirthScreen(
        updateDate,
      ),
      SexScreen(
        updateSex,
      ),
      HeightScreen(
        onHeightChanged: updateHeight,
        onWeightChanged: updateWeight,
      ),
      //ConfirmationScreen(),
    ];

    _tabController = TabController(vsync: this, length: _titles.length);
    _tabController.animation.addListener(() {
      int newIndex = _tabController.animation.value.round();
      if (_currentIndex != newIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
        if (_currentIndex == 1) {
          FocusScope.of(context).unfocus();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyTopBar(
          title: _titles[_currentIndex],
          onPressed: () {
            if (_currentIndex >= 0) {
              _tabController.animateTo(_currentIndex - 1);
            } else {
              //TODO: warning and logout

              Navigator.of(context).popAndPushNamed("/login");
            }
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight +
                          MediaQuery.of(context).viewInsets.bottom,
                      child: TabBarView(
                        controller: _tabController,
                        physics: BouncingScrollPhysics(),
                        children: _screens,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
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
                          color: index <= _currentIndex
                              ? MyColors.mainGreen
                              : Colors.grey),
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
                  text: _buttonText(),
                  color: _buttonColor(),
                  onPressed: _onNextPressed,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
