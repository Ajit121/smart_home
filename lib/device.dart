import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_home/data/Device.dart';
import 'package:smart_home/data/SwitchData.dart';
import 'package:smart_home/theme/Colors.dart';
import 'package:smart_home/theme/theme.dart';
import 'RadialDragGestureDetector.dart';
import 'main.dart';
import 'utils/TempretureSlider.dart';

class DevicePage extends StatefulWidget {
  final Device device;

  const DevicePage({Key key, this.device}) : super(key: key);

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage>
    with AfterLayoutMixin<DevicePage> {
  bool isUiLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: '${widget.device.deviceName}bg',
            child: Container(
              decoration: widgetDecoration,
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: HeaderWidget(
                      device: widget.device,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Hero(
                      tag: '${widget.device.deviceName}deviceList',
                      child: DevicesWidget()),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: new ControllerWidget(
                        device: widget.device,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Hero(
                        tag: '${widget.device.deviceName}controls',
                        child: new SwitchButtons()),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        isUiLoaded = true;
      });
    });
  }
}

class DevicesWidget extends StatefulWidget {
  const DevicesWidget({
    Key key,
  }) : super(key: key);

  @override
  _DevicesWidgetState createState() => _DevicesWidgetState();
}

class _DevicesWidgetState extends State<DevicesWidget> {
  final List<Device> _deviceList = [
    Device(
        deviceIcon: ('assets/ac.svg'),
        deviceName: 'Air conditionar',
        deviceDescription: 'Panasonic CS-VX18VKS',
        information: '29\u00BA C',
        isTurnedOn: true),
    Device(
        deviceIcon: ('assets/smart_tv.svg'),
        deviceName: 'Smart TV',
        deviceDescription: 'Sony BRAVIA KLV-10234',
        information: '29\u00BA C',
        isTurnedOn: false),
    Device(
        deviceIcon: ('assets/light.svg'),
        deviceName: 'Light Buld',
        deviceDescription: 'Philips Hue White A19 4',
        information: '29\u00BA C',
        isTurnedOn: false),
    Device(
        deviceIcon: ('assets/router.svg'),
        deviceName: 'Router',
        deviceDescription: 'Asus RT-AC1200',
        information: '29\u00BA C',
        isTurnedOn: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxHeight: 70),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _deviceList.forEach((place) {
                    place.isTurnedOn = false;
                  });
                  _deviceList[index].isTurnedOn =
                      !_deviceList[index].isTurnedOn;
                });
              },
              child: AnimatedContainer(
                duration: buttonAnimationDuration,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: _deviceList[index].isTurnedOn
                    ? widgetSelectedDecoration
                    : widgetDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                        _deviceList[index].deviceIcon,
                        height: 20,
                        width: 20,
                        color: subTitleTextColor,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Material(
                                color: Colors.transparent,
                                child: Text(
                                  _deviceList[index].deviceName,
                                  style: subTitleStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Material(
                                color: Colors.transparent,
                                child: Text(
                                  _deviceList[index].deviceDescription,
                                  style: subTitleStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: _deviceList.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
    ;
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
            //Navigator.of(context).pop();
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
    final ThemeData theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
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
        Hero(
          tag: '${widget.device.deviceName}textMessage',
          child: Container(width: double.infinity,
            child: Align(
              alignment: Alignment.center,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  'Set Tempreture',
                  style: titleStyle,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Hero(
          tag: '${widget.device.deviceName}slider',
          child: LayoutBuilder(
            builder: (context, constraints) => Container(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: constraints.maxWidth - 20,
                    decoration: widgetDecoration,
                    padding: const EdgeInsets.all(12),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: SliderTheme(
                      data: theme.sliderTheme.copyWith(
                        overlayColor: accentColor.withOpacity(0.12),
                        trackShape: MySliderTackShape(),
                        thumbShape: SliderHeaderPainter(),
                        valueIndicatorTextStyle: theme.accentTextTheme.bodyText1
                            .copyWith(color: theme.colorScheme.onSurface),
                      ),
                      child: Slider(
                        value: _currentTempreture.toDouble() / 100,
                        semanticFormatterCallback: (double value) =>
                            value.round().toString(),
                        onChanged: (double value) {
                          setState(
                            () {
                              _currentTempreture = (value * 100).toInt();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
        height: 180,
        width: 180,
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
                  child: Align(
                    alignment: Alignment.center,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.tempreture.toInt()}\u00B0 C',
                            style: TextStyle(
                                fontSize: 28,
                                color: accentColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Cool mood',
                            style: TextStyle(fontSize: 16, color: accentColor),
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
      ..color = backgroundColor
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

class SwitchButtons extends StatefulWidget {
  @override
  _SwitchButtonsState createState() => _SwitchButtonsState();
}

class _SwitchButtonsState extends State<SwitchButtons> {
  final switches = [
    SwitchData(iconName: 'assets/sun.svg', isActive: false),
    SwitchData(iconName: 'assets/aircon.svg', isActive: true),
    SwitchData(iconName: 'assets/fan.svg', isActive: false),
    SwitchData(iconName: 'assets/idea.svg', isActive: false),
    SwitchData(iconName: 'assets/power.svg', isActive: false),
    SwitchData(iconName: 'assets/moon.svg', isActive: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(30),
            child: SvgPicture.asset(
              'assets/switch.svg',
              width: 80,
              height: 80,
              color: accentColor,
            ),
            decoration: widgetDecoration,
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.1,
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.center,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          print('tapped');
                          setState(() {
                            switches.forEach((element) {
                              element.isActive = false;
                            });
                            switches[index].isActive = !switches[index].isActive;
                          });
                        },
                        child: AnimatedContainer(
                          duration: buttonAnimationDuration,
                          padding: const EdgeInsets.all(18),
                          decoration: switches[index].isActive
                              ? widgetSelectedDecoration
                              : widgetDecoration,
                          child: SvgPicture.asset(
                            switches[index].iconName,
                            width: 20,
                            height: 20,
                            color: subTitleTextColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: switches.length,
              ),
            ),
          ),
        )
      ],
    );
  }
}
