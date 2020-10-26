import 'package:higeia/data/date_value.dart';
import 'package:iirjdart/butterworth.dart';

const FREQ_LOW = 0.7;
const FREQ_HIGH = 4;
const FILTER_ORDER = 1;
const CAMERA_FS = 30;
const MAX_BPM = 180;
const MIN_BPM = 30;

class FilterPPG {
  Butterworth filter = Butterworth();
  FilterPPG() {
    filter.bandPass(FILTER_ORDER, CAMERA_FS.toDouble(),
        (FREQ_LOW + FREQ_HIGH) / 2, (FREQ_HIGH - FREQ_LOW) / 2);
  }

  double input(double value) {
    return filter.filter(value);
  }
}

class PeakFinder {
  double bpm;
  int window;
  final double alpha;
  final int beta;
  final int fs;
  final double minGap;
  List<int> peaksIdx = <int>[];
  List<DateValue> peaks = <DateValue>[];
  int _currentIndex = 0;
  List<DateValue> _currentWindow = [];
  List<double> maxBuffer = [0, 0, 0];
  List<int> idxBuffer = [-1, -1, -1];
  Function onNewPeak;
  DateValue middleBuffer;

  PeakFinder({
    this.alpha = 0.3,
    this.beta = 4,
    this.fs = 30,
    int initBPM = 90,
    this.minGap = 0.6,
    this.onNewPeak,
  }) {
    bpm = initBPM.toDouble();

    window = (fs * (60 / bpm) / beta).round();
  }

  void input(DateValue value) {
    _currentWindow.add(value);
    if (_currentWindow.length >= window) {
      _getMax(
        _currentWindow.toList(),
      );
      _currentWindow.clear();
    }
  }

  void _getMax(List<DateValue> currentWindow) async {
    maxBuffer.removeAt(0);
    idxBuffer.removeAt(0);
    int index = 0;
    double maxValue = currentWindow[0].value;
    for (int i = 1; i < currentWindow.length; i++) {
      if (currentWindow[i].value > maxValue) {
        maxValue = currentWindow[i].value;
        index = i;
      }
    }
    idxBuffer.add(_currentIndex + index);
    maxBuffer.add(maxValue);
    _currentIndex += currentWindow.length;

    if (idxBuffer[0] > -1 &&
        (maxBuffer[1] >= maxBuffer[0] && maxBuffer[1] > maxBuffer[2]) &&
        (peaks.length == 0 ||
            (idxBuffer[1] - peaksIdx.last) / fs >= minGap * 60 / bpm)) {
      if (peaks.length > 1) {
        // update window
        final int newBPM = (60 / ((idxBuffer[1] - peaksIdx.last) / fs)).round();
        if (newBPM > MIN_BPM && newBPM < MAX_BPM)
          bpm = alpha * newBPM + (1 - alpha) * bpm;
        window = (fs * (60 / bpm) / beta).round();
      }
      peaksIdx.add(idxBuffer[1]);
      peaks.add(middleBuffer);
      this.onNewPeak(middleBuffer);
    }
    middleBuffer = currentWindow[index];
  }
}
