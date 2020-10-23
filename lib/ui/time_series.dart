import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:higeia/utils/colors.dart';

typedef OnSelectionChanged(int index);

class TimeSeries extends StatefulWidget {
  const TimeSeries(this.data,
      {this.ticks,
      this.labels,
      this.start,
      this.end,
      this.onSelectionChanged,
      this.backgroundColors,
      this.colorTicks,
      this.lineColor = Colors.black,
      this.markerColor = MyColors.mainGreen,
      this.highlightColor = MyColors.mainOrange,
      this.markerRadius = 2,
      this.grid = true,
      this.selectedIndex,
      Key key})
      : super(key: key);

  final List<DateValue> data;
  final DateTime start;
  final DateTime end;
  final List<num> ticks;
  final List<String> labels;
  final OnSelectionChanged onSelectionChanged;
  final List<Color> backgroundColors;
  final List<num> colorTicks;
  final double markerRadius;
  final Color lineColor;
  final Color markerColor;
  final Color highlightColor;
  final bool grid;
  final int selectedIndex;

  @override
  _TimeSeriesState createState() => _TimeSeriesState();
}

class _TimeSeriesState extends State<TimeSeries> {
  DateTime start;
  DateTime end;
  charts.StaticNumericTickProviderSpec tickProvider;
  List<charts.RangeAnnotationSegment> _backgroundColors;

  @override
  void initState() {
    super.initState();
    if (widget.ticks != null) {
      tickProvider = charts.StaticNumericTickProviderSpec(
        List.generate(
          widget.ticks.length,
          (int index) => charts.TickSpec(widget.ticks[index],
              label: (widget.labels != null) ? widget.labels[index] : ""),
        ),
      );
    }
    if (widget.backgroundColors != null &&
        widget.colorTicks != null &&
        widget.backgroundColors.length == widget.colorTicks.length - 1) {
      _backgroundColors = List.generate(
        widget.colorTicks.length - 1,
        (int index) => charts.RangeAnnotationSegment(
          widget.colorTicks[index],
          widget.colorTicks[index + 1],
          charts.RangeAnnotationAxisType.measure,
          startLabel: '',
          endLabel: '',
          labelAnchor: charts.AnnotationLabelAnchor.start,
          color: charts.ColorUtil.fromDartColor(widget.backgroundColors[index]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedIndex != null) {
      start = widget.data[widget.selectedIndex].timestamp
          .subtract(Duration(days: 3));
      end = widget.data[widget.selectedIndex].timestamp.add(Duration(days: 3));

      if (start.isBefore(widget.data.first.timestamp)) {
        start = widget.data.first.timestamp;
        end = start.add(Duration(days: 7));
      }
      if (end.isAfter(widget.data.last.timestamp)) {
        end = widget.data.last.timestamp;
        start = end.subtract(Duration(days: 7));
      }
    } else {
      end = widget.end ?? DateTime.now();
      start = widget.start ?? end.subtract(Duration(days: 7));
    }
    return charts.TimeSeriesChart(
      [
        charts.Series<DateValue, DateTime>(
          id: 'data',
          domainFn: (DateValue dateValue, _) => dateValue.timestamp,
          measureFn: (DateValue dateValue, _) => dateValue.value,
          data: widget.data,
          colorFn: (DateValue dateValue, _) => charts.ColorUtil.fromDartColor(
            widget.lineColor,
          ),
        ),
        charts.Series<DateValue, DateTime>(
            id: 'markers',
            colorFn: (DateValue dateValue, _) => charts.ColorUtil.fromDartColor(
                  widget.markerColor,
                ),
            domainFn: (DateValue dateValue, _) => dateValue.timestamp,
            measureFn: (DateValue dateValue, _) => dateValue.value,
            radiusPxFn: (DateValue dateValue, _) => dateValue.timestamp ==
                    widget.data[widget.selectedIndex].timestamp
                ? widget.markerRadius * 0.7
                : widget.markerRadius,
            strokeWidthPxFn: (DateValue dateValue, _) => dateValue.timestamp ==
                    widget.data[widget.selectedIndex].timestamp
                ? widget.markerRadius * 0.7
                : 0,
            fillColorFn: (DateValue dateValue, _) =>
                charts.ColorUtil.fromDartColor(dateValue.timestamp ==
                        widget.data[widget.selectedIndex].timestamp
                    ? Colors.white
                    : widget.markerColor),
            data: widget.data)
          // Configure our custom point renderer for this series.
          ..setAttribute(charts.rendererIdKey, 'customPoint'),
        // Default symbol renderer ID for data that have no defined shape.
      ],
      animate: false,
      behaviors: [
        new charts.PanAndZoomBehavior(),
        new charts.RangeAnnotation(_backgroundColors ?? []),
        charts.LinePointHighlighter(
          showHorizontalFollowLine:
              charts.LinePointHighlighterFollowLineType.none,
          showVerticalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
          symbolRenderer: CustomCircleSymbolRenderer(),
        ),
      ],
      customSeriesRenderers: [
        new charts.PointRendererConfig(
            // ID used to link series to this renderer.
            radiusPx: widget.markerRadius,
            customSymbolRenderers: {
              'circle': new charts.CircleSymbolRenderer(),
              'rect': new charts.RectSymbolRenderer(),
            },
            customRendererId: 'customPoint')
      ],
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: tickProvider ??
            charts.BasicNumericTickProviderSpec(desiredTickCount: 5),
        renderSpec: widget.grid
            ? null
            : charts.SmallTickRendererSpec(
                tickLengthPx: 0,
                // Tick and Label styling here.
              ),
      ),
      domainAxis: charts.DateTimeAxisSpec(
        tickProviderSpec:
            charts.AutoDateTimeTickProviderSpec(includeTime: true),
        viewport: charts.DateTimeExtents(
          start: start,
          end: end,
        ),
      ),
      selectionModels: [
        new charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (charts.SelectionModel model) {
            if (model.selectedDatum.isNotEmpty &&
                widget.onSelectionChanged != null) {
              widget.onSelectionChanged(model.selectedDatum.first.index);
            }
          },
        )
      ],
    );
  }
}

class DateValue {
  final DateTime timestamp;
  final num value;

  DateValue(this.timestamp, this.value);
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  static String value;
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.FillPatternType fillPattern,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillPattern: fillPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10,
            bounds.height + 10),
        fill: charts.Color.white);
  }
}

class LinearSales {
  final int year;
  final int sales;
  LinearSales(this.year, this.sales);
}
