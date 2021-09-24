import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/main.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_sleep.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AlarmWidget extends StatefulWidget {
  final bool isManage, toChange;
  final getDoc;
  final int i;
  AlarmWidget(this.toChange,this.isManage,this.getDoc, this.i);

  @override
  _AlarmWidgetState createState() => _AlarmWidgetState();
}

class _AlarmWidgetState extends State<AlarmWidget> {
  
  @override
  Widget build(BuildContext context) {
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    UserSleep userSleep = Provider.of<UserSleep>(context);
    return Stack(
      children: [
        AnimatedPositioned(
          left: widget.toChange ? widget.isManage ? 30 : 60 : 60,
          duration:  Duration(milliseconds: 600),
          child: AnimatedOpacity(
            opacity: widget.toChange ? widget.isManage ? 1 : 0 : 0,
            duration: Duration(milliseconds: widget.isManage ? 200 : 0),
            child: IconButton(icon: Icon(Icons.delete, color: kRedColor,), onPressed: (){userSleep.deleteAlarm(userinfo.userId,widget.getDoc["time"]);},))
        ),

        AnimatedPositioned(
          left: widget.toChange ? widget.isManage ? 60 : 10 : 10,
          top:10,
          duration:  Duration(milliseconds: 700 ),
          child: AnimatedOpacity(
            opacity: widget.toChange ? widget.isManage ? 0 : 1 : 1,
            duration: Duration(milliseconds: widget.isManage ? 0 : 200 ),
            child: FlutterSwitch(
              value: widget.getDoc["switch"],
              activeColor: kGreenColor,
              width: 60,
              height: 30,
              borderRadius: 30.0,
              onToggle: (val) {
                setState(() {
                  String formattedTime = DateFormat("HH:mm:ss").format(DateTime.now());
                  DateTime alarm ;
                  DateTime now = DateTime(0,0,0,int.parse(formattedTime.split(":")[0]),int.parse(formattedTime.split(":")[1]),int.parse(formattedTime.split(":")[2]));
                  if(val){
                    //if hour of now is larger than the alarm hour => it's probably ringing on next day
                    if(int.parse(formattedTime.split(":")[0]) > int.parse(widget.getDoc["time"].split(":")[0])){
                      alarm = DateTime(0,0,1,int.parse(widget.getDoc["time"].split(":")[0]),int.parse(widget.getDoc["time"].split(":")[1]),0);
                    }else{
                      alarm = DateTime(0,0,0,int.parse(widget.getDoc["time"].split(":")[0]),int.parse(widget.getDoc["time"].split(":")[1]),0);
                    }

                    final duration = alarm.difference(now).toString().replaceAll("-", "");
                    int hour = int.parse(duration.split(":")[0]) ?? 0;
                    int min = int.parse(duration.split(":")[1]) ?? 0;
                    int sec = int.parse((duration.split(":")[2]).split(".")[0]) ?? 0;
                    var scheduledNotificationDateTime = DateTime.now().add(Duration(hours: hour, minutes: min, seconds: sec));
                    scheduleAlarm(scheduledNotificationDateTime, widget.i, userSleep.updateAlarm, userinfo.userId, widget.getDoc["time"]);
                    Timer(Duration(hours: hour, minutes: min, seconds: sec), () {
                      userSleep.updateAlarm(userinfo.userId, false, widget.getDoc["time"]);
                    });
                  }else{
                    flutterLocalNotificationsPlugin.cancel(widget.i);
                  }
                  userSleep.updateAlarm(userinfo.userId, val, widget.getDoc["time"]);
                });
              },
            ),
          ),
        ),
      ],
    );

  }
}

void scheduleAlarm(DateTime scheduledNotificationDateTime, int id, Function updateAlarm, String userid, String time) async{
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'codex_logo',
      sound: RawResourceAndroidNotificationSound('wake_up'),
      largeIcon: DrawableResourceAndroidBitmap('music'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'wake_up.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    
    await flutterLocalNotificationsPlugin.schedule(id, 'Wake Up', "It's $time!",
      scheduledNotificationDateTime, platformChannelSpecifics);

}