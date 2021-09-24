import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_kit/health_kit.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class PedometerWidget extends StatefulWidget {
  @override
  _PedometerWidgetState createState() => _PedometerWidgetState();
}

class _PedometerWidgetState extends State<PedometerWidget> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getSteps()); 
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  var total = 0.0;

  Future<bool> readPermissionsForHealthKit() async {
    try {
      final responses = await HealthKit.hasPermissions([DataType.STEP_COUNT]);

      if (!responses) {
        final value = await HealthKit.requestPermissions([DataType.STEP_COUNT]);

        return value;
      } else {
        return true;
      }
    } on UnsupportedException catch (e) {
      // thrown in case e.dataType is unsupported
      print(e);
      return false;
    }
  }

  void getSteps() async {
    var permissionsGiven = await readPermissionsForHealthKit();

    if (permissionsGiven) {
      var current = DateTime.now();

      var dateFrom = DateTime.now().subtract(Duration(
        hours: current.hour,
        minutes: current.minute,
        seconds: current.second,
      ));
      var dateTo = dateFrom.add(Duration(
        hours: 23,
        minutes: 59,
        seconds: 59,
      ));

      try {
        var results = await HealthKit.read(
          DataType.STEP_COUNT,
          dateFrom: dateFrom,
          dateTo: dateTo,
        );
        if (results != null) {
          total = 0;
          for (var result in results) {
            setState(() {
              total += result.value;
            });
          }
        }
      } on Exception catch (ex) {
        print('Exception in getYesterdayStep: $ex');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width:double.infinity,
      height:60,
      margin: EdgeInsets.symmetric(horizontal: 60),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/img/steps.png", width: 30,),
          SizedBox(width:10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(total?.toString()?.split(".")[0] ?? '0', style: TextStyle(color: kGreenColor, fontWeight: FontWeight.bold, fontFamily: "Roboto", fontSize: 25),),
              Padding(
                padding: const EdgeInsets.only(bottom:3),
                child: Text(" steps today", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto", fontSize: 17),),
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kWhiteColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0.0,2.0),
            color: Colors.black26,
          ),
        ]
      ),
    );
  }
}