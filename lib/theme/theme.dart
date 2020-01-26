import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_home/theme/Colors.dart';

const TextStyle titleStyle =
    const TextStyle(color: titleTextColor, fontSize: 18);
const TextStyle subTitleStyle =
    const TextStyle(color: subTitleTextColor, fontSize: 12);

const double _blurRadius = 4;
const double _spreadRadius = 1;
const double _offset = 2;
BoxDecoration widgetDecoration = BoxDecoration(
  color: backgroundColor,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
        color: Darker,
        offset: Offset(_offset, _offset),
        blurRadius: _blurRadius,
        spreadRadius: _spreadRadius),
    BoxShadow(
        color: Brighter,
        offset: Offset(-_offset, -_offset),
        blurRadius: _blurRadius,
        spreadRadius: _spreadRadius),
  ],
);

BoxDecoration widgetSelectedDecoration = BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(5),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.deepOrange[900], Colors.deepOrange],
    ));
