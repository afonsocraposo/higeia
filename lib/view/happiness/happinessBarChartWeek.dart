part of 'happinessView.dart';

class HappinessBarChartWeek extends StatelessWidget {
  const HappinessBarChartWeek(this.happinessValues, {Key key})
      : super(key: key);
  final List<Happiness> happinessValues;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BarChart(
        BarChartData(
            alignment: BarChartAlignment.center,
            maxY: 5,
            minY: 0,
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) =>
                    const TextStyle(color: Colors.black, fontSize: 14),
                margin: 20,
                getTitles: (double value) {
                  switch (value.toInt()) {
                    case 1:
                      return 'Mon';
                    case 2:
                      return 'Tue';
                    case 3:
                      return 'Wed';
                    case 4:
                      return 'Thu';
                    case 5:
                      return 'Fri';
                    case 6:
                      return 'Sat';
                    case 7:
                      return 'Sun';
                    default:
                      return '';
                  }
                },
              ),
              leftTitles: SideTitles(
                showTitles: false,
                getTextStyles: (value) =>
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                margin: 20,
                getTitles: (double value) {
                  switch (value.toInt()) {
                    case 1:
                      return '😭';
                    case 2:
                      return '🙁';
                    case 3:
                      return '😐';
                    case 4:
                      return '🙂';
                    case 5:
                      return '😁';
                    default:
                      return '';
                  }
                },
              ),
            ),
            barGroups: _happinessValues
                .map(
                  (Happiness happiness) => BarChartGroupData(
                    x: happiness.timestamp.weekday,
                    barRods: [
                      BarChartRodData(
                        y: happiness.value.toDouble(),
                        width: 24,
                        colors: [HAPPINESS_COLORS[happiness.value]],
                      ),
                    ],
                  ),
                )
                .toList(),
            barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String weekDay;
                      switch (group.x.toInt()) {
                        case 0:
                          weekDay = 'Monday';
                          break;
                        case 1:
                          weekDay = 'Tuesday';
                          break;
                        case 2:
                          weekDay = 'Wednesday';
                          break;
                        case 3:
                          weekDay = 'Thursday';
                          break;
                        case 4:
                          weekDay = 'Friday';
                          break;
                        case 5:
                          weekDay = 'Saturday';
                          break;
                        case 6:
                          weekDay = 'Sunday';
                          break;
                      }
                      return BarTooltipItem(
                          weekDay + '\n' + (rod.y - 1).toString(),
                          TextStyle(color: Colors.yellow));
                    }),
                touchCallback: (barTouchResponse) {
                  //
                })),
      ),
    );
  }
}
