import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:higeia/values/colors.dart';

typedef OnSelectionChanged(DateTime dateTime);

class TimeSeriesBar extends StatefulWidget {
  const TimeSeriesBar(this.data,
      {this.loadWeeks,
      this.ticks,
      this.colors = const [MyColors.mainGreen],
      this.start,
      this.end,
      this.onStartReached,
      this.onEndReached,
      this.onSelectionChanged,
      Key key})
      : super(key: key);

  final List<DateValue> data;
  final Function onStartReached;
  final Function onEndReached;
  final OnSelectionChanged onSelectionChanged;
  final DateTime start;
  final DateTime end;
  final int loadWeeks;
  final List<Widget> ticks;
  final List<Color> colors;

  @override
  _TimeSeriesBarState createState() => _TimeSeriesBarState();
}

class _TimeSeriesBarState extends State<TimeSeriesBar> {
  ScrollController _controller = ScrollController();
  bool _startReached = false;
  bool _endReached = false;
  DateTime _prevStart;
  DateTime _prevEnd;

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () {
        if (_controller.offset < -50) {
          if (!_endReached) {
            _prevEnd = widget.data.last.timestamp;

            _endReached = true;
            widget.onEndReached();
          }
        } else if (_controller.offset >
            _controller.position.maxScrollExtent + 50) {
          if (!_startReached) {
            _prevStart = widget.data.first.timestamp;
            _startReached = true;
            widget.onStartReached();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_startReached && _prevStart != widget.data.first.timestamp)
      setState(() => _startReached = false);
    if (_endReached && _prevEnd != widget.data.last.timestamp)
      setState(() => _endReached = false);

    List<DateValue> _data = List.generate(
      widget.end.difference(widget.start).inDays + 1,
      (int index) => DateValue(
          widget.data.first.timestamp.add(
            Duration(
              days: index * 1,
            ),
          ),
          0),
      growable: false,
    );

    int j = 0;
    int count;
    num sum;
    DateTime timestamp;
    for (int i = 0; i < _data.length; i++) {
      count = 0;
      sum = 0;
      timestamp = _data[i].timestamp;
      while (j < widget.data.length &&
          _data[i].timestamp.difference(widget.data[j].timestamp).inDays == 0) {
        count++;
        sum += widget.data[j].value;
        j++;
      }
      if (count > 0) _data[i] = DateValue(timestamp, sum / count);
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 16,
              ),
              child: SizedBox(
                width: constraints.maxWidth - 16,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: _controller,
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: (constraints.maxWidth - 16) * widget.loadWeeks,
                    child: charts.TimeSeriesChart(
                      [
                        charts.Series<DateValue, DateTime>(
                          id: 'data',
                          domainFn: (DateValue dateValue, _) =>
                              dateValue.timestamp,
                          measureFn: (DateValue dateValue, _) =>
                              dateValue.value,
                          data: _data,
                          colorFn: (DateValue dateValue, _) =>
                              (widget.colors.length == 1
                                  ? charts.ColorUtil.fromDartColor(
                                      widget.colors.first)
                                  : charts.ColorUtil.fromDartColor(
                                      widget.colors[dateValue.value.toInt()],
                                    )),
                        ),
                      ],
                      animate: true,
                      defaultRenderer: charts.BarRendererConfig<DateTime>(
                        cornerStrategy: const charts.ConstCornerStrategy(30),
                      ),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        tickProviderSpec: charts.StaticNumericTickProviderSpec(
                          List.generate(
                            6,
                            (int index) => charts.TickSpec(index, label: ""),
                          ),
                        ),
                        //renderSpec: charts.NoneRenderSpec(),
                      ),
                      domainAxis: new charts.DateTimeAxisSpec(
                        viewport: new charts.DateTimeExtents(
                          start: widget.start,
                          end: widget.end,
                        ),
                      ),
                      selectionModels: [
                        new charts.SelectionModelConfig(
                          type: charts.SelectionModelType.info,
                          changedListener: (charts.SelectionModel model) {
                            final selectedDatum = model.selectedDatum;
                            if (selectedDatum.isNotEmpty) {
                              widget.onSelectionChanged(
                                  selectedDatum.first.datum.timestamp);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 40,
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: widget.ticks,
              ),
            ),
          ],
        );
      },
    );
  }
}

