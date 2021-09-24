

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/models/calorie.dart';

class UserFoodIntake extends ChangeNotifier{
  List<dynamic> _items = [];

  List<dynamic> get items{
    return [..._items];
  }
 
  //show list of food
  void foodintake(String id) {
    _items = [];
    Firestore.instance.collection("foods").snapshots().listen((data) {
      data.documents.forEach((element) {
        if(element.documentID == id){
          element.data.forEach((key, value) {
            _items = value;
          });
        }
      });
    });
  }


  //add food
  Future<void> addFood(String id, Calorie cal) async {
    List newlist = [..._items];
    DocumentReference docRef = Firestore.instance.collection("foods").document(id);
    newlist.add({
      "title":cal.title,
      "calorie":cal.calorie,
      "date":cal.datetime, 
      "calorie_id": docRef.documentID
    });
    docRef.setData({
      'list': newlist,
    });
  }

   //delete food
  Future<void> deleteFood(String id, Calorie cal) async {
    List newlist = [..._items];
    newlist.removeWhere((element) => element["title"] == cal.title && element["date"] == cal.datetime && element["calorie"] == cal.calorie);
    Firestore.instance.collection("foods").document(id).setData({
      'list': newlist,
    });
  }

}