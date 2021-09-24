import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/models/water.dart';

class UserWaterIntake extends ChangeNotifier{
  List<dynamic> _items = [];

  List<dynamic> get items{
    return [..._items];
  }
 


  void waterintake(String id) {
    Firestore.instance.collection("water").snapshots().listen((data) {
      data.documents.forEach((element) {
        if(element.documentID == id){
          element.data.forEach((key, value) {
            _items = value;
          });
        }
      });
    });
  }


  //add water
  //id as in user id
  Future<void> addWater(String id, Water wat) async {
    List newlist = [..._items];
    DocumentReference docRef = Firestore.instance.collection("water").document(id);
    if(_items.isNotEmpty){
      bool checking = false;
      _items.forEach((element) {
        if(element["date"] == wat.datetime){
          checking = true;
        }
      });
      if(checking){
        int index = _items.indexOf(_items.firstWhere((element) => element["date"] == wat.datetime));
        _items[index] = {
          "date": wat.datetime, 
          "water_id":docRef.documentID, 
          "height":wat.height
        };
        newlist[index] = _items[index];
      }else
      newlist.add({"date": wat.datetime, "water_id":docRef.documentID, "height":wat.height});
    }else
    newlist.add({"date": wat.datetime, "water_id":docRef.documentID, "height":wat.height});
    docRef.setData({
      'list': newlist,
    });
  }

  

}