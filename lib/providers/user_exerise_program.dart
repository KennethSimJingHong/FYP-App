import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/models/exercise.dart';
import 'package:intl/intl.dart';

class UserExerciseProgram extends ChangeNotifier{
  var formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  List<dynamic> _items = [];
  List<dynamic> _items2 = [];

  List<dynamic> get items{
    return [..._items];
  }

    List<dynamic> get items2{
    return [..._items2];
  }

  //show list of exercise
  void exerciseList(String id){
    _items = [];
    _items2 = [];
    Firestore.instance.collection("exercise").snapshots().listen((data) {
      data.documents.forEach((element) {
        print(element.documentID);
        print(id);
        if(element.documentID == id){
          element.data.forEach((key, value) { 
            if(key == "list"){
              _items = value;
            }else if(key == "date"){
              _items2 = value;
            }
            print(_items);
          });
        }
      });
    });
  }

  //add exercise
  Future<void> addExercise(String id, Exercise exe) async {
    List newlist = [..._items];

    DocumentReference docRef = Firestore.instance.collection("exercise").document(id);
    if(newlist.isEmpty){
      newlist.add({"title":exe.title,"description":exe.desc,"duration":exe.duration,"status":exe.status, "exercise_id": docRef.documentID});
      docRef.setData({
        'list': newlist,
      });
    }else{
      newlist.add({"title":exe.title,"description":exe.desc,"duration":exe.duration,"status":exe.status, "exercise_id": docRef.documentID});
      Firestore.instance.collection("exercise").document(id).updateData({
        'list': newlist,
      });
    }
  }

  // delete exercise
  Future<void> deleteExercise(String id, Exercise exe) async{
    List newlist = [..._items];
    newlist.removeWhere((element) => element["title"] == exe.title && element["description"] == exe.desc && element["duration"] == exe.duration);
    Firestore.instance.collection("exercise").document(id).updateData({
      'list': newlist,
    });
  }

  //update today exercise
  Future<void> updateTodayExercise(String id, Exercise exe) async {
    _items2.add({"title":exe.title,"description":exe.desc,"duration":exe.duration,"date":formattedDate});
    Firestore.instance.collection("exercise").document(id).updateData({
      'date': _items2,
    });
  }

  //remove today exercise
  Future<void> removeTodayExercise(String id, Exercise exe) async {
    _items2.removeWhere((element) => element["title"] == exe.title && element["description"] == exe.desc && element["duration"] == exe.duration && element["date"] == formattedDate);
    Firestore.instance.collection("exercise").document(id).updateData({
      'date': _items2,
    });
  }
}