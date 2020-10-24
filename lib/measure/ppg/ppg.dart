import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manual_camera/camera.dart';
import 'package:higeia/data/date_value.dart';
import 'package:higeia/data/fixed_list.dart';
import 'package:higeia/utils/image_utils.dart';
import 'package:screen/screen.dart';

class PPG extends StatefulWidget {
  const PPG({Key key}) : super(key: key);

  @override
  _PPGState createState() => _PPGState();
}

const CAMERA_FS = 30;

class _PPGState extends State<PPG> {
  CameraController _cameraController;
  CameraImage _image;
  DateTime _now;
  bool _cameraActive = false;
  CameraDescription _frontCamera;
  FixedList<DateValue> _ppg;
  Timer _frameTimer;
  Timer _drawTimer;
  bool _readyAcquisition = false;
  double brightness;
  String videoPath;
  int windowSize = CAMERA_FS * 5;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      setState(() {
        _frontCamera = cameras[1];
        _cameraController = CameraController(_frontCamera, ResolutionPreset.low,
            enableAudio: false);
      });
      _cameraController.initialize().then((value) {
        setState(() {});
      });
    });
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Screen.brightness.then((brightness) => this.brightness = brightness);
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
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Screen.setBrightness(1); // Set the brightness
    Screen.keepOn(true); // Prevent screen from going into sleep mode
    _now = DateTime.now();
    _ppg = FixedList(windowSize, defaultValue: DateValue(_now, 0.0));

    setState(() {
      _cameraActive = true;
      _readyAcquisition = true;
    });
    _startImageStream().then((value) {
      _initFrameTimer();
    });
  }

  void _stopAcquisition() async {
    _cameraController.stopImageStream();
    Screen.keepOn(false);
    Screen.setBrightness(brightness);
    setState(() {
      _cameraActive = false;
    });
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
          _now = _now.add(Duration(milliseconds: 1000 ~/ CAMERA_FS));
          _scanImage(_image);
        }
      } else {
        timer.cancel();
      }
    });
    _drawTimer = Timer.periodic(Duration(milliseconds: 1000 ~/ 10), (timer) {
      if (_cameraActive && mounted) {
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  void _scanImage(CameraImage image) async {
    final List<double> rgbValues = await ImageUtils.meanRGB(image);

    //_values.add(SensorValue(_now, sp.lastRatio.roundToDouble()));
    //_ppg.add(
    //DateValue(_now, ),
    //);
  }

  @override
  void dispose() {
    if (_cameraActive) {
      _stopAcquisition();
    }
    _cameraController?.dispose();
    _frameTimer?.cancel();
    _drawTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
