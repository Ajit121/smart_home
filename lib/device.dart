import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_home/data/Device.dart';
import 'package:smart_home/theme/Colors.dart';
import 'package:smart_home/theme/theme.dart';
import 'package:smart_home/utils.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'dart:math' as math;

import 'RadialDragGestureDetector.dart';

class DevicePage extends StatelessWidget {
  final Device device;

  const DevicePage({Key key, this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: '${device.deviceName}bg',
            child: Container(
              decoration: widgetDecoration,
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  new HeaderWidget(
                    device: device,
                  ),
                  new ControllerWidget(
                    device: device,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final Device device;

  const HeaderWidget({Key key, this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print('HeaderWidget width $width');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Hero(
            tag: device.deviceIcon,
            child: Container(
              margin: const EdgeInsets.all(4),
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              decoration: widgetDecoration,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Hero(
              tag: device.deviceName,
              child: Material(
                color: backgroundColor,
                child: Text(
                  device.deviceName,
                  style: titleStyle,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Hero(
            tag: '${device.deviceIcon}2',
            child: Container(
              margin: const EdgeInsets.all(4),
              child: Icon(
                Icons.add,
                size: 16,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              decoration: widgetDecoration,
            ),
          ),
        ),
      ],
    );
  }
}

class ControllerWidget extends StatefulWidget {
  final Device device;

  const ControllerWidget({Key key, this.device}) : super(key: key);

  @override
  _ControllerWidgetState createState() => _ControllerWidgetState();
}

class _ControllerWidgetState extends State<ControllerWidget> {
  double _startDragPercent = 0;
  double _blurRadius = 4;
  double _spreadRadius = 1;
  double _offset = 4;
  int _currentTempreture = 0;

  void onTempretureUpdate(int tempreture) {
    setState(() {
      _currentTempreture = tempreture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: '${widget.device.deviceName}tempreture',
              child: Material(
                color: backgroundColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Darker,
                          offset: Offset(_offset, _offset),
                          blurRadius: _blurRadius,
                          spreadRadius: _spreadRadius),
                      BoxShadow(
                          color: backgroundColor,
                          offset: Offset(-_offset, -_offset),
                          blurRadius: _blurRadius,
                          spreadRadius: _spreadRadius),
                    ],
                  ),
                  child: TempretureDial(
                    tempreture: _currentTempreture.toInt(),
                    onTempretureUpdate: onTempretureUpdate,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 40,
            ),
            Hero(
              tag: '${widget.device.deviceName}slider',
              child: Container(
                child: Stack(
                  children: <Widget>[
                    TempretureSlider(
                        tempreture: _currentTempreture,
                        onTempretureUpdate: onTempretureUpdate),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TempretureDial extends StatefulWidget {
  int tempreture;

  Function(int tempreture) onTempretureUpdate;

  TempretureDial({this.tempreture, this.onTempretureUpdate});

  @override
  _TempretureDialState createState() => _TempretureDialState();
}

class _TempretureDialState extends State<TempretureDial> {
  double _startDragPercent = 0;

  double _currentDragPercent;

  double _currentTempreture = 0;

  PolarCoord _startDragCoord;

  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      onRadialDragUpdate: (PolarCoord coord) {
        final dragAngle = coord.angle - _startDragCoord.angle;
        final dragPercent = dragAngle / (2 * pi);

        setState(() {
          _currentDragPercent = (_startDragPercent + dragPercent) % 1.0;
          _currentTempreture = _currentDragPercent * 101;
        });
        widget.onTempretureUpdate(_currentTempreture.toInt());
      },
      onRadialDragStart: (PolarCoord coord) {
        _startDragCoord = coord;
        _startDragPercent = _currentTempreture / 101;
      },
      child: Container(
        child: CustomPaint(
          foregroundPainter: TempretureIndicator(tempreture: widget.tempreture),
          child: Container(
            decoration: tempretureDialDecoration(),
            child: Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(5),
              decoration: tempretureDialDecoration(),
              child: CustomPaint(
                foregroundPainter:
                    TempretureProgressBar(tempreture: widget.tempreture),
                child: Container(
                  margin: const EdgeInsets.all(28),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${widget.tempreture.toInt()}\u00B0 C',
                          style: TextStyle(fontSize: 28, color: accentColor),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Cool mood',
                          style: TextStyle(fontSize: 14, color: accentColor),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TempretureProgressBar extends CustomPainter {
  final int tempreture;

  TempretureProgressBar({this.tempreture});

  @override
  void paint(Canvas canvas, Size size) {
    Paint progressPaint = Paint()
      ..color = accentColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    double arcAngle = 2 * pi * (tempreture / 100);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, progressPaint);

    Paint progressHeader = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..color = accentColor;

    final progress = tempreture / 100;
    final thumbAngle = 2 * pi * progress - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = new Offset(thumbX, thumbY) + center;
    final thumbRadius = 5.0;

    Paint progressHoleHeader = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    canvas.drawCircle(
      thumbCenter,
      thumbRadius,
      progressHeader,
    );
    canvas.drawCircle(
      thumbCenter,
      thumbRadius / 2,
      progressHoleHeader,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TempretureIndicator extends CustomPainter {
  final int tempreture;

  TempretureIndicator({this.tempreture});

  final linePainter = Paint()
    ..color = lineColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;
  final double lineHeight = 8;
  final int maxLines = 12;
  final previousPoint = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    final circleWidth = 12.0;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    Paint indicatorPaint = Paint()
      ..strokeWidth = circleWidth
      ..color = Brighter
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, indicatorPaint);

    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();

    List.generate(maxLines, (i) {
      final a1 = Offset(0, radius + 5);
      final b1 = Offset(0, radius - 5);

      final rotationAngle = 2 * pi / maxLines;


      canvas.drawLine(a1, b1, linePainter);

      canvas.rotate(rotationAngle);
    });

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

BoxDecoration tempretureDialDecoration() => BoxDecoration(
    color: backgroundColor,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Darker,
        blurRadius: 1,
        spreadRadius: 0,
        offset: Offset(2, 2),
      ),
      BoxShadow(
        color: Brighter,
        blurRadius: 1,
        spreadRadius: 0,
        offset: Offset(-2, -2),
      ),
    ],
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [LightBrighter, backgroundColor]));

class TempretureSlider extends StatefulWidget {
  final tempreture;
  final Function(int tempreture) onTempretureUpdate;

  TempretureSlider({Key key, this.tempreture, this.onTempretureUpdate})
      : super(key: key);

  @override
  _TempretureSliderState createState() => _TempretureSliderState();
}

class _TempretureSliderState extends State<TempretureSlider> {
  double width;
  double position = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      width = constraints.maxWidth;
      position = (constraints.maxWidth / 100) * widget.tempreture;
      print('TempretureSlider width ${constraints.maxWidth}');
      return Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: widgetDecoration,
            child: Stack(
              children: <Widget>[
                CustomPaint(
                  foregroundPainter: SliderBackgroundPainter(),
                  child: Container(
                    width: double.infinity,
                  ),
                ),
                CustomPaint(
                  foregroundPainter:
                      SliderPainter(tempreture: widget.tempreture),
                  child: Container(
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
              left: (position - (constraints.maxWidth / 2)) - 130,
              child: GestureDetector(
                onHorizontalDragUpdate: _onDrag,
                child: Container(
                  child: SvgPicture.asset(
                    'assets/ac.svg',
                    color: Colors.red,
                    width: 0,
                  ),
                ),
              )

              /* CustomPaint(
              foregroundPainter: SliderHeaderPainter(tempreture: widget.tempreture),
              child: GestureDetector(
                onHorizontalDragUpdate: _onDrag,
                child: Container(
                  child: SvgPicture.asset(
                    'assets/ac.svg',
                    color: Colors.red,
                    width: double.infinity,
                  ),
                ),
              ),
            ),*/
              ),
        ],
      );
    });
  }

  _onDrag(DragUpdateDetails details) {
    // position += details.delta.dx+1;
    final localTouchOffset = (context.findRenderObject() as RenderBox)
        .globalToLocal(details.globalPosition);
    position = localTouchOffset.dx;
    final progress = (position / width) * 100;
    print('progress $progress');
    widget.onTempretureUpdate(progress.toInt());
  }
}

class SliderBackgroundPainter extends CustomPainter {
  final sliderPaint = Paint()
    ..color = backgroundColor
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 26;

  final sliderHolePaint = Paint()
    ..color = LightBrighter
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 10;

  @override
  void paint(Canvas canvas, Size size) {
    final startOffset = Offset(0, 0);
    final endOffset = Offset(size.width, 0);
    canvas.drawLine(startOffset, endOffset, sliderPaint);
    canvas.drawLine(startOffset, endOffset, sliderHolePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class SliderPainter extends CustomPainter {
  final tempreture;

  final sliderPaint = Paint()
    ..color = accentColor
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 10;

  SliderPainter({this.tempreture});

  @override
  void paint(Canvas canvas, Size size) {
    final startOffset = Offset(0, 0);
    final progress = (size.width / 100) * tempreture;
    final endOffset = Offset(progress, 0);
    canvas.drawLine(startOffset, endOffset, sliderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class SliderHeaderPainter extends CustomPainter {
  final tempreture;

  final _progressHeaderCirclePaint = Paint()
    ..strokeWidth = 8
    ..color = accentColor
    ..style = PaintingStyle.fill;

  final _progressHeaderHolePaint = Paint()
    ..strokeWidth = 4
    ..color = backgroundColor
    ..style = PaintingStyle.fill;

  SliderHeaderPainter({this.tempreture});

  final circleRadius = 16.0;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = (size.width / 100) * tempreture;
    // final center = Offset(size.width / 2, size.height / 2);

    final endOffset = Offset(progress, size.height / 2);

    final radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(endOffset, radius, _progressHeaderCirclePaint);
    canvas.drawCircle(endOffset, radius / 2, _progressHeaderHolePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
