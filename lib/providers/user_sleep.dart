

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/sleep.dart';

class UserSleep extends ChangeNotifier{
  List<dynamic> _items = [];
  List<dynamic> _items2 = [];

  List<dynamic> get items{
    return [..._items];
  }

  List<dynamic> get items2{
    return [..._items2];
  }

  void sleepList(String id){
    _items = [];
    _items2 = [];
    Firestore.instance.collection("sleep").snapshots().listen((data) {
      data.documents.forEach((element) {
        if(element.documentID == id){
          element.data.forEach((key, value) {
            _items = value;
          });
        }
      });
    });
  }

  //show list of alarm
  void alarmList(String id){
    Firestore.instance.collection("alarm").snapshots().listen((data) {
      data.documents.forEach((element) {
        if(element.documentID == id){
          element.data.forEach((key, value) { 
            _items2 = value;
          });
        }
      });
    });
  }


  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute/60.0;
  double truncateToHundreths(num value) => (value * 100).truncate() / 100;

  // sleep record
  Future<void> updateSleep(Sleep sleep, BuildContext context) async {
    List newlist = [..._items];
    DateTime startD = DateTime.parse(sleep.sleepDateTime + ":00.000");
    DateTime endD = DateTime.parse(sleep.wakeDateTime + ":00.000");
    Firestore.instance.collection("sleep").getDocuments().then((value) {
      bool found = false;
      String toDeleteStartDT;
      String toDeleteEndDT;
      if(value != null)
      value.documents.forEach((doc){
        if(doc.documentID == sleep.sleepId)
        doc.data["list"].forEach((element){
          DateTime start = DateTime.parse(element["sleep_datetime"] + ':00.000');
          DateTime end = DateTime.parse(element["wake_datetime"] + ':00.000');
            if(start.isAtSameMomentAs(startD) || start.isAtSameMomentAs(endD) || end.isAtSameMomentAs(startD) || end.isAtSameMomentAs(endD) || 
            (startD.isBefore(start)) ||
            (startD.isAfter(start) && ( endD.isBefore(end) || endD.isAtSameMomentAs(end))) || 
            (endD.isBefore(end) && (startD.isAtSameMomentAs(start) || startD.isAfter(start)))){
              found = true;
              toDeleteStartDT = element["sleep_datetime"];
              toDeleteEndDT = element["wake_datetime"];
            }
          });
        }
      );
      if(!found){
        newlist.add({"sleep_datetime": sleep.sleepDateTime, "wake_datetime": sleep.wakeDateTime, "sleep_id": sleep.sleepId, "duration": sleep.duration});
        Firestore.instance.collection("sleep").document(sleep.sleepId).setData({
          "list":newlist,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your sleep is recorded."), backgroundColor: kGreenColor));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sorry, the date has been recorded previously."), backgroundColor: Theme.of(context).errorColor, action: SnackBarAction(label: 'Delete record?', onPressed: (){
          newlist.removeWhere((element) => element["sleep_datetime"] == toDeleteStartDT && element["wake_datetime"] == toDeleteEndDT);
          Firestore.instance.collection("sleep").document(sleep.sleepId).setData({
            "list":newlist,
          });
        }, textColor: kWhiteColor,),));
      }
    });


  }

  //add alarm
  Future<void> addAlarm(String id, bool isOn, String time, BuildContext context) async {
    List newlist = [..._items2];
    if(newlist.isEmpty){
      newlist.add({"alarm_id":id, "switch":isOn,"time":time});
      Firestore.instance.collection("alarm").document(id).setData({
        'alarm': newlist,
      });
    }else{
      bool checking = false;
      newlist.forEach((element) {
        if(element["time"] == time){
          checking = true;
        }
      });

      if(checking){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The alarm has already existed."), backgroundColor: Theme.of(context).errorColor,));
      }else{
        newlist.add({"alarm_id":id, "switch":isOn,"time":time});
        Firestore.instance.collection("alarm").document(id).updateData({
          'alarm': newlist,
        });
      }
    }
  }

  //delete alarm
  Future<void> deleteAlarm(String id, String time) async {
    List newlist = [..._items2];
    newlist.removeWhere((element) => element["alarm_id"] == id && element["time"] == time);
    Firestore.instance.collection("alarm").document(id).updateData({
      'alarm': newlist,
    });
  }

  //update alarm
  Future<void> updateAlarm(String id, bool isOn, String time) async {
    List newlist = [..._items2];
    final index = newlist.indexWhere((element) => element["time"] == time);
    newlist[index] = {"alarm_id":id,"switch":isOn,"time":time};
    Firestore.instance.collection("alarm").document(id).updateData({
      'alarm': newlist,
    });
  }


}