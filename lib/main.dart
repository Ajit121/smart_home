import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/utils/SliderDemo.dart';
import 'package:smart_home/data/Device.dart';
import 'package:smart_home/device.dart';
import 'package:smart_home/theme/Colors.dart';
import 'package:smart_home/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'data/Place.dart';

const Duration buttonAnimationDuration = Duration(milliseconds: 200);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart home',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: backgroundColor,
          primaryTextTheme: TextTheme()),
      home: MyHomePage(title: 'Flutter Smart home ui'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: true,
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: new InfoWidget(),
            ),
            SizedBox(
              height: 40,
            ),
            new PlacesWidget(),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: Text(
                'Connected Devices',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            new DivicesWidget(),
            SizedBox(
              height: 20,
            ),
            new BottomWidget()
          ],
        ),
      ),
    );
  }
}

class InfoWidget extends StatefulWidget {
  const InfoWidget({
    Key key,
  }) : super(key: key);

  @override
  _InfoWidgetState createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Living Room',
                style: titleStyle,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '3 Devices connected',
                  style: subTitleStyle,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    decoration: widgetDecoration,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tempIconColorBackground),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: SvgPicture.asset(
                              'assets/temprature.svg',
                              height: 12,
                              width: 12,
                              color: tempIconColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                          child: Text(
                            '29\u00BA C',
                            style:
                                TextStyle(fontSize: 12, color: tempIconColor),
                          ),
                        ),

                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    decoration: widgetDecoration,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: humidityIconColorBackground),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: SvgPicture.asset(
                              'assets/humidity.svg',
                              height: 12,
                              width: 12,
                              color: humidityIconColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                          child: Text(
                            '47%',
                            style: TextStyle(
                                fontSize: 12, color: humidityIconColor),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class PlacesWidget extends StatefulWidget {
  PlacesWidget({
    Key key,
  }) : super(key: key);

  @override
  _PlacesWidgetState createState() => _PlacesWidgetState();
}

class _PlacesWidgetState extends State<PlacesWidget> {
  List<Place> _placeList = [
    Place(
        placeIcon: ('assets/bedroom.svg'),
        placeName: 'Bedroom',
        devices: 3,
        isTurnedOn: false),
    Place(
        placeIcon: ('assets/bedroom.svg'),
        placeName: 'Living Room',
        devices: 6,
        isTurnedOn: true),
    Place(
        placeIcon: ('assets/kitchen.svg'),
        placeName: 'Kitchen',
        devices: 3,
        isTurnedOn: false),
    Place(
        placeIcon: ('assets/dining.svg'),
        placeName: 'Dining',
        devices: 6,
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
                  _placeList.forEach((place) {
                    place.isTurnedOn = false;
                  });
                  _placeList[index].isTurnedOn = !_placeList[index].isTurnedOn;
                });
              },
              child: AnimatedContainer(
                duration: buttonAnimationDuration,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.fromLTRB(20,10,20,10),
                decoration: _placeList[index].isTurnedOn
                    ? widgetSelectedDecoration
                    : widgetDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                        _placeList[index].placeIcon,
                        height: 20,
                        width: 20,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          _placeList[index].placeName,
                          style: subTitleStyle,
                        ),
                        Text(
                          '${_placeList[index].devices.toString()} devices',
                          style: subTitleStyle,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: _placeList.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

class DivicesWidget extends StatefulWidget {
  DivicesWidget({
    Key key,
  }) : super(key: key);

  @override
  _DivicesWidgetState createState() => _DivicesWidgetState();
}

class _DivicesWidgetState extends State<DivicesWidget> {
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
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1.1),
        itemCount: _deviceList.length,
        semanticChildCount: 2,
        itemBuilder: (context, index) {
          return Stack(
            children: <Widget>[
              Hero(
                tag: '${_deviceList[index].deviceName}bg',
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  padding: const EdgeInsets.all(20),
                  decoration: widgetDecoration,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DevicePage(
                          device: _deviceList[index],
                        ),
                          // SliderDemo(),
                        transitionDuration: const Duration(milliseconds: 1000),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Hero(
                            tag: _deviceList[index].deviceIcon,
                            child: SvgPicture.asset(
                              _deviceList[index].deviceIcon,
                              width: 24,
                              height: 24,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Hero(
                              tag: '${_deviceList[index].deviceIcon}2',
                              child: Container())
                        ],
                      ),
                      Hero(
                        tag: _deviceList[index].deviceName,
                        child: Material(
                          color: backgroundColor,
                          child: Text(
                            _deviceList[index].deviceName,
                            style: titleStyle,
                          ),
                        ),
                      ),
                      Hero(tag:'${_deviceList[index].deviceName}deviceList',child: Container(),),
                      Text(
                        _deviceList[index].deviceDescription,
                        style: subTitleStyle,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Hero(
                              tag: '${_deviceList[index].deviceName}tempreture',
                              child: Material(
                                color: backgroundColor,
                                child: Text(
                                  _deviceList[index].information,
                                  style: titleStyle,
                                ),
                              ),
                            ),
                          ),
                          Hero(tag: '${_deviceList[index].deviceName}textMessage',child: Container(),),
                          Transform.scale(
                            scale: .7,
                            child: Hero(
                              tag: '${_deviceList[index].deviceName}slider',
                              child: CupertinoSwitch(
                                value: _deviceList[index].isTurnedOn,
                                onChanged: (isOn) {
                                  setState(() {
                                    _deviceList[index].isTurnedOn = isOn;
                                  });
                                },
                                activeColor: Colors.deepOrange,
                                dragStartBehavior: DragStartBehavior.start,
                              ),
                            ),
                          )
                        ],
                      ),
                      Hero(tag:'${_deviceList[index].deviceName}controls' ,child: Container()),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        shrinkWrap: true,
      ),
    );
  }
}

class BottomWidget extends StatelessWidget {
  const BottomWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          margin: const EdgeInsets.all(20),
          decoration: widgetDecoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: widgetSelectedDecoration,
                child: SvgPicture.asset(
                  'assets/home.svg',
                  height: 32,
                  width: 32,
                  color: Colors.white,
                ),
              ),
              SvgPicture.asset(
                'assets/user.svg',
                height: 32,
                width: 32,
                color: Colors.white,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: widgetDecoration.copyWith(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
