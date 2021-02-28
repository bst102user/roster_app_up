import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:seekbar/seekbar.dart';

class Test extends StatefulWidget{
  TestState createState() => TestState();
}
class TestState extends State<Test>{
  // double _value = 0.0;
  // double _secondValue = 0.0;
  //
  // Timer _progressTimer;
  // Timer _secondProgressTimer;
  double _lowerValue = 50;
  double _upperValue = 180;

  bool _done = false;
  customHandler(IconData icon) {
    return FlutterSliderHandler(
      decoration: BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Icon(
          icon,
          color: Colors.green,
          size: 23,
        ),
      ),
    );
  }
  Widget getDivider(double size,Color color){
    return Container(
        width: size,
        child: Divider(
          color: Colors.transparent,
          height: 70,
          thickness: 1.5,
        )
    );
  }
  Widget smallCircle(){
    return Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Container()
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('slider'),
      ),
      body: Column(children: <Widget>[
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 17.5),
              child: Text(
                '20',
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text(
                '100',
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: Text(
                '100',
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: Text(
                '100',
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: Text(
                '100',
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: FlutterSlider(
                    values: [3000, 17000],
                    rangeSlider: false,
                    max: 25000,
                    min: 0,
                    step: FlutterSliderStep(step: 100),
                    jump: true,
                    trackBar: FlutterSliderTrackBar(
                      inactiveTrackBarHeight: 2,
                      activeTrackBarHeight: 2,
                      inactiveTrackBar: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                        // border: Border.all(width: 3, color: Colors.green),
                      ),
                      activeTrackBar: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.green),
                    ),

                    disabled: false,

                    handler: customHandler(Icons.place),

                    onDragging: null
                )),
            Row(children: <Widget>[
              getDivider(20, Colors.transparent),
              smallCircle(),
              getDivider(50, Colors.transparent),
              smallCircle(),
              getDivider(50, Colors.grey),
              smallCircle(),
              getDivider(50, Colors.grey),
              smallCircle(),
              getDivider(50, Colors.grey),
              smallCircle(),
              getDivider(20, Colors.grey),
            ]),
          ],
        ),
      ]),
    );
  }

}