
import 'package:flutter/material.dart';
import 'package:smart_home/theme/Colors.dart';
import 'dart:math' as math;

class MySliderTackShape extends SliderTrackShape {
  final sliderPaint = Paint()
    ..color = accentColor
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  final sliderHolePaint = Paint()
    ..color = LightBrighter
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  @override
  void paint(PaintingContext context, Offset offset,
      {RenderBox parentBox,
        SliderThemeData sliderTheme,
        Animation<double> enableAnimation,
        Offset thumbCenter,
        bool isEnabled,
        bool isDiscrete,
        TextDirection textDirection}) {


    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Size thumbSize =
    sliderTheme.thumbShape.getPreferredSize(isEnabled, isDiscrete);
    final Rect leftTrackSegment = Rect.fromLTRB(
        trackRect.left + trackRect.height / 2,
        trackRect.top,
        thumbCenter.dx - thumbSize.width / 2,
        trackRect.bottom);
    if (!leftTrackSegment.isEmpty)
      context.canvas.drawLine(Offset(trackRect.left,trackRect.top), Offset(leftTrackSegment.right,trackRect.top), sliderPaint);

    final Rect rightTrackSegment = Rect.fromLTRB(
        thumbCenter.dx + thumbSize.width / 2,
        trackRect.top,
        trackRect.right,
        trackRect.bottom);

    if (!rightTrackSegment.isEmpty) {

      context.canvas.drawLine(Offset(rightTrackSegment.left,trackRect.top), Offset(trackRect.right,rightTrackSegment.top), sliderHolePaint);


    }
  }

  @override
  Rect getPreferredRect(
      {RenderBox parentBox,
        Offset offset = Offset.zero,
        SliderThemeData sliderTheme,
        bool isEnabled,
        bool isDiscrete}) {

    final double thumbWidth =
        sliderTheme.thumbShape.getPreferredSize(isEnabled, isDiscrete).width;
    final double overlayWidth =
        sliderTheme.overlayShape.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight;

    final double trackLeft = offset.dx + overlayWidth / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth =
        parentBox.size.width - math.max(thumbWidth, overlayWidth);
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}



class SliderHeaderPainter extends SliderComponentShape {
  final tempreture;

  final _progressHeaderCirclePaint = Paint()
    ..strokeWidth = 6
    ..color = accentColor
    ..style = PaintingStyle.fill;

  final _progressHeaderHolePaint = Paint()
    ..strokeWidth = 3
    ..color = backgroundColor
    ..style = PaintingStyle.fill;

  SliderHeaderPainter({this.tempreture});

  final circleRadius = 12.0;

  @override
  void paint(PaintingContext context, Offset thumbCenter,
      {Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete,
        TextPainter labelPainter,
        RenderBox parentBox,
        SliderThemeData sliderTheme,
        TextDirection textDirection,
        double value}) {
    final Canvas canvas = context.canvas;

    var size = 12.0;

    canvas.drawCircle(thumbCenter, size, _progressHeaderCirclePaint);
    canvas.drawCircle(thumbCenter, size / 2, _progressHeaderHolePaint);
  }

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(10);
  }
}

