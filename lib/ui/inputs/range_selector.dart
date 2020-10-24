import 'dart:async';

import 'package:flutter/material.dart';
import 'package:higeia/values/colors.dart';

typedef OnItemSelected = void Function(num selectedValue);

class RangeSelector extends StatefulWidget {
  const RangeSelector(this.minValue, this.maxValue,
      {this.title = "",
      this.unit = "",
      this.step = 1,
      this.itemHeight = 40,
      this.itemWidth = 60,
      this.initialValue,
      this.onItemSelected,
      Key key})
      : super(key: key);

  final num minValue;
  final num maxValue;
  final num step;
  final double itemHeight;
  final double itemWidth;
  final num initialValue;
  final String title;
  final String unit;
  final OnItemSelected onItemSelected;

  @override
  _RangeSelectorState createState() => _RangeSelectorState();
}

class _RangeSelectorState extends State<RangeSelector> {
  ScrollController _controller;
  double _prevOffset;
  int _currentIndex = 0;

  void _sticky() {
    if (_controller.hasClients) {
      Timer.periodic(
        Duration(
          milliseconds: 33,
        ),
        (Timer timer) {
          if (_prevOffset == _controller.offset) {
            timer.cancel();
            _controller.animateTo(
              widget.itemHeight * _currentIndex,
              duration: Duration(
                milliseconds: 33,
              ),
              curve: Curves.easeOut,
            );
            widget
                .onItemSelected(_currentIndex * widget.step + widget.minValue);
          }
          _prevOffset = _controller.offset;
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null)
      _currentIndex = (widget.initialValue - widget.minValue) ~/ widget.step;
    _prevOffset = widget.itemHeight * _currentIndex;

    _controller = ScrollController(initialScrollOffset: _prevOffset);
    _controller.addListener(() {
      setState(() {
        _currentIndex =
            (_controller.offset + widget.itemHeight / 2) ~/ widget.itemHeight;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) {
        _sticky();
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Icon(
                  Icons.arrow_right,
                  color: MyColors.mainGreen,
                  size: 40,
                ),
              ),
              SizedBox(
                width: widget.itemWidth,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: widget.itemHeight * 1.3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.itemWidth),
                        color: Colors.orange.withAlpha(25),
                      ),
                    ),
                    ListWheelScrollView(
                      physics: BouncingScrollPhysics(),
                      diameterRatio: 1.5,
                      controller: _controller,
                      itemExtent: widget.itemHeight,
                      children: List.generate(
                        ((widget.maxValue - widget.minValue) / widget.step)
                                .round() +
                            1,
                        (int index) {
                          int _index = widget.minValue + index * widget.step;
                          bool isCentered = _currentIndex == index;
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              _index.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isCentered ? 24 : 18,
                                color: isCentered
                                    ? MyColors.mainGreen
                                    : Colors.black,
                                fontWeight: isCentered
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  widget.unit,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MyColors.mainGreen,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: widget.itemHeight * 0.4),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
