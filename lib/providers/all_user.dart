

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AllUser extends ChangeNotifier{
  List<Map<String,dynamic>> _users = [];


  List<Map<String,dynamic>>get users{
    return [..._users];
  }

  //show all the users
  List<Map<String,dynamic>> retrieveUsers() {
    _users = [];
    Firestore.instance.collection("users").snapshots().listen((data) {
      data.documents.forEach((element) {
        Map<String,dynamic> data = element.data;
        data["user_id"] = element.documentID;
        _users.add(data);
      });
      return _users;
    });
    return null;
  }
}