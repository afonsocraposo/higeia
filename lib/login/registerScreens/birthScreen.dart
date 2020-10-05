import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/colors.dart';

class BirthScreen extends StatefulWidget {
  const BirthScreen(this.updateDate, {Key key}) : super(key: key);
  final Function updateDate;

  @override
  _BirthScreenState createState() => _BirthScreenState();
}

class _BirthScreenState extends State<BirthScreen> {
  DateTime _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ??
          DateTime(DateTime.now().year - 18, DateTime.now().month,
              DateTime.now().day),
      firstDate: DateTime(
          DateTime.now().year - 100, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(
          DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
            accentColor: const Color(0xFF8CE7F1),
            colorScheme: ColorScheme.light(
              primary: MyColors.mainGreen,
              brightness: Brightness.light,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      widget.updateDate(picked);
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          alignment: Alignment.center,
          child: _selectedDate == null
              ? Container()
              : Text(
                  "You're ${getAge(_selectedDate)} y.o.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "What's your birthdate?",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                width: double.infinity,
                child: FlatButton(
                  onPressed: () async {
                    _selectDate(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Colors.grey.withAlpha(50),
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    child: Text(
                      _selectedDate != null
                          ? "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"
                          : "Click here",
                      style: TextStyle(
                        fontSize: 18,
                        color:
                            _selectedDate != null ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: SvgPicture.asset(
            "assets/images/personal-information-right.svg",
            width: 188,
          ),
        ),
      ],
    );
  }

  getAge(DateTime birthDate) {
    final now = new DateTime.now();

    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    int days = now.day - birthDate.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
      months += (days < 0 ? 11 : 12);
    }

    if (days < 0) {
      final monthAgo = new DateTime(now.year, now.month - 1, birthDate.day);
      days = now.difference(monthAgo).inDays + 1;
    }

    return years;
  }
}
