import 'package:charts_common/common.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';
import 'package:higeia/data/date_value.dart';
import 'package:higeia/values/colors.dart';
import 'package:intl/intl.dart';

class SensorChart extends StatelessWidget {
  final List<DateValue> data;
  final List<DateValue> peaks;
  final double offset;

  SensorChart(this.data, {this.peaks, this.offset = 0});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<dynamic, DateTime>> _series = [
      charts.Series<DateValue, DateTime>(
        id: 'Values',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(MyColors.mainGreen),
        domainFn: (DateValue values, _) => values.timestamp,
        measureFn: (DateValue values, _) => values.value + this.offset,
        data: data,
      ),
    ];
    if (peaks != null) {
      _series.add(
        charts.Series<DateValue, DateTime>(
          id: 'Peaks',
          colorFn: (_, __) =>
              charts.ColorUtil.fromDartColor(MyColors.mainOrange),
          domainFn: (DateValue value, _) => value.timestamp,
          measureFn: (DateValue value, _) => value.value + this.offset,
          data: peaks,
        )..setAttribute(charts.rendererIdKey, 'customPoint'),
      );
    }
    return new charts.TimeSeriesChart(
      _series,
      defaultRenderer:
          new LineRendererConfig(includeArea: true, strokeWidthPx: 3),
      customSeriesRenderers: [
        new charts.PointRendererConfig(
            radiusPx: 4,
            // ID used to link series to this renderer.
            customRendererId: 'customPoint')
      ],
      animate: false,
      behaviors: [
        new charts.LinePointHighlighter(
            showHorizontalFollowLine:
                charts.LinePointHighlighterFollowLineType.none,
            showVerticalFollowLine:
                charts.LinePointHighlighterFollowLineType.none),
        new charts.SelectNearest(eventTrigger: null),
      ],
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec:
            new charts.BasicNumericTickProviderSpec(zeroBound: false),
        renderSpec: NoneRenderSpec(),
        showAxisLine: false,
      ),
      domainAxis: DateTimeAxisSpec(
        showAxisLine: false,
        tickProviderSpec: DateTimeEndPointsTickProviderSpec(),
        tickFormatterSpec:
            BasicDateTimeTickFormatterSpec.fromDateFormat(DateFormat.ms()),
        renderSpec: NoneRenderSpec(),
      ),
      layoutConfig: charts.LayoutConfig(
          leftMarginSpec: MarginSpec.fixedPixel(0),
          rightMarginSpec: MarginSpec.fixedPixel(0),
          topMarginSpec: MarginSpec.fixedPixel(0),
          bottomMarginSpec: MarginSpec.fixedPixel(0)),
    );
  }
}

