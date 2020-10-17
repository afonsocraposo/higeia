part of 'happinessView.dart';

class HappinessBarChart extends StatefulWidget {
  const HappinessBarChart(this.happinessValues, {Key key}) : super(key: key);

  final List<Happiness> happinessValues;

  @override
  _HappinessBarChartState createState() => _HappinessBarChartState();
}

class _HappinessBarChartState extends State<HappinessBarChart> {
  static const List<Color> _barColors = <Color>[
    Colors.red,
    Colors.orange,
    Colors.yellow,
    MyColors.mainBlue,
    MyColors.mainGreen
  ];

  int touchedIndex;

  List<Happiness> _happinessValues = [];

  @override
  void initState() {
    super.initState();
    DateTime prevDateTime = widget.happinessValues.last.timestamp;
    int happiness = 0;
    int count = 0;
    for (int i = widget.happinessValues.length - 1; i >= 0; i--) {
      Happiness currentHappiness = widget.happinessValues[i];
      if (currentHappiness.timestamp.weekday == prevDateTime.weekday) {
        count++;
        happiness = happiness + currentHappiness.value;
      } else {
        _happinessValues.add(
          Happiness(value: happiness ~/ count, timestamp: prevDateTime),
        );
        count = 1;
        happiness = currentHappiness.value;
        prevDateTime = currentHappiness.timestamp;
      }
    }
    _happinessValues.add(
      Happiness(value: happiness ~/ count, timestamp: prevDateTime),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(happinessBarChartWeek());
  }
}
