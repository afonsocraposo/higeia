part of 'happiness_view.dart';

class HappinessDetailed extends StatefulWidget {
  const HappinessDetailed(this.happiness, {Key key}) : super(key: key);

  final Happiness happiness;

  @override
  _HappinessDetailedState createState() => _HappinessDetailedState();
}

class _HappinessDetailedState extends State<HappinessDetailed> {
  bool _edit = false;
  Happiness _happiness;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    _happiness = widget.happiness.duplicate();
    _edit = false;
  }

  void _updateHappiness() {
    HappinessFunctions.updateHappiness(_happiness);
  }

  @override
  Widget build(BuildContext context) {
    if (_happiness.timestamp != widget.happiness.timestamp) _reset();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: AnimatedContainer(
            duration: SHORT_ANIMATION,
            curve: ANIMATION_CURVE,
            width: _edit ? 150 : 50,
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              reverse: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      HappinessFunctions.removeHappiness(_happiness.id);
                    },
                    color: Colors.red,
                    icon: Icon(
                      Icons.delete,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _edit = !_edit);
                    },
                    icon: Icon(
                      Icons.close,
                    ),
                  ),
                  MaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minWidth: 0,
                    onPressed: () {
                      if (_edit) _updateHappiness();
                      setState(() => _edit = !_edit);
                    },
                    color: MyColors.mainGreen,
                    shape: CircleBorder(),
                    child: Icon(
                      _edit ? Icons.check : Icons.edit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Text(
              "I was feeling...",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
        _edit
            ? HappinessSlider(_happiness.value, (double value) {
                setState(() {
                  _happiness.value = value.toInt();
                });
              }, null)
            : Text(
                HAPPINESS_EMOJIS[_happiness.value - 1],
                style: TextStyle(fontSize: 48),
              ),
        Container(height: 300),
      ],
    );
  }
}
