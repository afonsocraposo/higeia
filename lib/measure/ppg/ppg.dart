import 'dart:async';

import 'package:flutter/material.dart';
import 'package:higeia/utils/csvFile.dart';
import 'package:higeia/utils/fire_functions.dart';
import 'package:sensors/sensors.dart';
import 'package:higeia/measure/ppg/heart_clip_path.dart';
import 'package:higeia/ui/charts/sensor_chart.dart';
import 'package:higeia/ui/topbars/my_top_bar.dart';
import 'package:higeia/utils/signal_pocessing.dart';
import 'package:manual_camera/camera.dart';
import 'package:higeia/data/date_value.dart';
import 'package:higeia/data/fixed_list.dart';
import 'package:higeia/utils/image_utils.dart';
import 'package:screen/screen.dart';
import 'dart:math';

class PPG extends StatefulWidget {
  const PPG({Key key}) : super(key: key);

  @override
  _PPGState createState() => _PPGState();
}

const CAMERA_FS = 30;

const PULSE_ANIMATION_SCALE = 0.2;
const ANIMATION_FPS = 20;
const REFRESH_RATE = 30;
const RECORDING_SECONDS = 20;

class _PPGState extends State<PPG> {
  CameraController _cameraController;
  CameraImage _image;
  DateTime _now;
  bool _cameraActive = false;
  CameraDescription _backCamera;
  Timer _frameTimer;
  Timer _drawTimer;
  bool _recording = false;
  String videoPath;
  static final int windowSize = CAMERA_FS * 3;
  FixedList<DateValue> _ppg =
      FixedList(windowSize, defaultValue: DateValue(DateTime.now(), 0.0));
  FilterPPG filterPPG = FilterPPG();
  double _animationValue = 0;
  bool _animationForward = true;
  bool _animate = true;
  double _bpm;
  List<DateValue> _recordedValues = [];
  List<DateValue> _peaks = [];
  PeakFinder _peakFinder;
  // Phone inertial sensors
  UserAccelerometerEvent _accelerometer;
  GyroscopeEvent _gyroscope;
  // Threshold for some motion factor (combination of accelerometers and gyroscopes)
  int _motionFactorThresh = 1;
  int _recordingSeconds = 0;
  String _filename;
  CSVFile _csvFile;
  bool _saveData = false;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      _backCamera = cameras[0];
      _cameraController = CameraController(
        _backCamera,
        ResolutionPreset.low,
        iso: 6400,
        shutterSpeed: CAMERA_FS,
        focusDistance: 0.01,
        enableAudio: false,
        whiteBalance: WhiteBalancePreset.daylight,
      );
      _cameraController.initialize().then((value) {
        setState(() {});
        Future.delayed(
          Duration(
            milliseconds: 1000,
          ),
        ).then((_) => _cameraController.flash(true));
        _startAcquisition();
      });
    });

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _accelerometer = event;
    });

    // Gyroscope
    gyroscopeEvents.listen((GyroscopeEvent event) {
      _gyroscope = event;
    });

    _filename = DateTime.now().millisecondsSinceEpoch.toString();
    _csvFile = CSVFile(_filename)..init();
  }

  void _updateAnimation() async {
    await Future.delayed(
      Duration(milliseconds: 1000 ~/ ANIMATION_FPS),
    );
    double step = ((_bpm ?? 0) / 30) * PULSE_ANIMATION_SCALE / ANIMATION_FPS;
    if (mounted && _animate) {
      if (_animationForward)
        _animationValue += step;
      else
        _animationValue -= step;
      if (_animationValue > PULSE_ANIMATION_SCALE) {
        _animationValue = PULSE_ANIMATION_SCALE;
        _animationForward = false;
      } else if (_animationValue < 0) {
        _animationValue = 0;
        _animationForward = true;
      }
      _updateAnimation();
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_cameraController != null) {
        _cameraController.initialize().then((value) {
          setState(() {});
        });
      }
    }
  }

  void _startAcquisition() async {
    Screen.keepOn(true); // Prevent screen from going into sleep mode
    _now = DateTime.now();
    _ppg = FixedList(windowSize, defaultValue: DateValue(_now, 0.0));

    setState(() {
      _cameraActive = true;
    });
    _startImageStream().then((value) {
      _initFrameTimer();
    });
  }

  Future<void> _stopAcquisition() async {
    try {
      await _cameraController?.stopImageStream();
    } catch (Exception) {
      //print(Exception);
    }
    Screen.keepOn(false);
    _cameraActive = false;
    _recording = false;
    _saveData = false;
  }

  Future<void> _startImageStream() async {
    try {
      await _cameraController.startImageStream((CameraImage image) {
        _image = image;
      });
    } catch (Exception) {
      debugPrint(Exception);
    }
  }

  void _initFrameTimer() {
    _frameTimer =
        Timer.periodic(Duration(milliseconds: 1000 ~/ CAMERA_FS), (timer) {
      if (_cameraActive && mounted) {
        if (_image != null) {
          _scanImage(_image, _now);
          _now = _now.add(Duration(milliseconds: 1000 ~/ CAMERA_FS));
        }
      } else {
        timer.cancel();
      }
    });
    _drawTimer =
        Timer.periodic(Duration(milliseconds: 1000 ~/ REFRESH_RATE), (timer) {
      if (_cameraActive && mounted) {
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  void _startRecordingTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_recording) {
        _recordingSeconds++;
        if (_recordingSeconds >= RECORDING_SECONDS) {
          await _stopAcquisition();
          await _csvFile.closeFile();
          bool success = await PPGFunctions.uploadPPGFile(_csvFile.file);
          if (success) {
            _csvFile.delete();
          } else {
            print("ERROR!!!!");
          }
          Navigator.of(context).pop();
        }
      } else {
        _recordingSeconds = 0;
        timer.cancel();
      }
    });
  }

  bool _isFingerOn(double red, double green, double blue) {
    return red > green * 2 && red > blue * 2;
  }

  bool _isMoving() {
    final double gx = _gyroscope?.x ?? 0;
    final double gy = _gyroscope?.y ?? 0;
    final double gz = _gyroscope?.z ?? 0;

    final double ax = _accelerometer?.x ?? 0;
    final double ay = _accelerometer?.y ?? 0;
    final double az = _accelerometer?.z ?? 0;

    final double acelEucl = sqrt(pow(ax, 2) + pow(ay, 2) + pow(az, 2));
    final double gyrEucl = sqrt(pow(gx, 2) + pow(gy, 2) + pow(gz, 2));

    if (acelEucl > _motionFactorThresh || gyrEucl > _motionFactorThresh) {
      return true;
    } else {
      return false;
    }
  }

  void _scanImage(CameraImage image, DateTime now) async {
    final List<double> rgbValues = await ImageUtils.meanRGB(image);
    final double value = filterPPG.input(255 - rgbValues[0]);
    final DateValue dateValue = DateValue(now, value);
    _ppg.add(
      dateValue,
    );
    if (_peaks.length > 0 &&
        _peaks.first.timestamp.isBefore(_ppg.first.timestamp)) {
      _peaks.removeAt(0);
    }
    if (_isFingerOn(rgbValues[0], rgbValues[1], rgbValues[2]) && !_isMoving()) {
      if (!_recording) {
        _recording = true;
        _peakFinder = PeakFinder(
          onNewPeak: updatePeaks,
          beta: 3,
          minGap: 0.7,
          alpha: 0.4,
        );
        _startAnimation();
        _startRecordingTimer();
        Future.delayed(Duration(seconds: 2)).then((_) {
          if (_recording) _saveData = true;
        });
        print("start");
      }
      _peakFinder.input(dateValue);
      if (_saveData) {
        _csvFile.writeRow([
          dateValue.timestamp.millisecondsSinceEpoch,
          dateValue.value,
        ]);
      }
    } else {
      if (_recording) {
        _recording = false;
        _saveData = false;
        _peakFinder = null;
        _stopAnimation();
        _csvFile.reset();
        print("stop");
      }
    }
  }

  void _startAnimation() {
    _animate = true;
    _updateAnimation();
  }

  void _stopAnimation() {
    _animate = false;
  }

  void updatePeaks(DateValue value) async {
    _bpm = _peakFinder.bpm;
    _peaks.add(
      value,
    );
  }

  Future<void> disposeCamera() async {
    await _stopAcquisition();
    await _cameraController?.dispose();
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    _drawTimer?.cancel();
    disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyTopBar(
          title: "PPG",
          onPressed: () {
            Navigator.of(context).pop();
          }),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(
                  "Cover the flash and back camera with your index finger"),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 128,
                  height: 128,
                  alignment: Alignment.center,
                  child: _cameraPreviewWidget(),
                ),
                SizedBox(height: 16),
                Text(
                  _bpm?.toStringAsFixed(0) ?? "--",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("bpm"),
                SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: SensorChart(_ppg, peaks: _peaks, offset: 255),
          ),
        ],
      ),
    );
  }

  Widget _cameraPreviewWidget() => LayoutBuilder(
        builder: (context, constraints) => Transform.scale(
          scale: 1 - _animationValue,
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxWidth,
            child: ClipPath(
              clipper: HeartClipPath(),
              child: (_cameraController == null ||
                      !_cameraController.value.isInitialized)
                  ? Container(color: Colors.red)
                  : AspectRatio(
                      aspectRatio: _cameraController.value.aspectRatio,
                      child: CameraPreview(_cameraController),
                    ),
            ),
          ),
        ),
      );
}
