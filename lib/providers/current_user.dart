
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_lifestyle_app/models/user.dart';

class CurrentUser extends ChangeNotifier{
  String _uid;
  String _username;
  String _password;
  String _email;
  String _gender;
  int _age;
  double _weight;
  double _height;
  double _exerciseduration;
  String _exerciselevel;
  String _image;
  

  get currentUserInfo{
    return User(_uid, _username, _email, _password, _gender, _age, _weight, _height, _exerciseduration, _exerciselevel, _image);
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signUpUser(String username, String email, String password, String gender, int age, double weight, double height, double exerciseduration, String exerciselevel, File image) async{
    bool retVal = false;
    try{
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      if (_authResult.user != null){

        final ref = FirebaseStorage.instance.ref().child("userImage").child(_authResult.user.uid + ".jpg");
        await ref.putFile(image).onComplete;
        final url = await ref.getDownloadURL();

        DocumentReference docRef = Firestore.instance.collection("users").document(_authResult.user.uid);
        docRef.setData({
          "user_id" : docRef.documentID,
          'username' : username,
          'email_address' : email,
          'gender':gender,
          'age':age,
          'weight':weight,
          'height':height,
          'exercise_duration':exerciseduration,
          'exercise_level':exerciselevel,
          'image_url':url,
        });
        retVal = true;
      }
      
    }catch(e){
      print(e);
      return true;
    }
    return retVal;
  }
  

  Future<bool> loginUser(String email, String password, BuildContext context) async{
    bool retVal = false;
    try{
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      if (_authResult.user != null){
        retVal = true;

        Firestore.instance.collection("users").snapshots().listen((data) {
          data.documents.forEach(
            (element) {
              if(element.documentID == _authResult.user.uid){
                _uid = _authResult.user.uid;
                _username = element["username"];
                _password = element["password"];
                _email = element["email_address"];
                _gender = element["gender"];
                _age = element["age"];
                _weight = element["weight"];
                _height = element["height"];
                _exerciseduration = element["exercise_duration"];
                _exerciselevel = element["exercise_level"];
                _image = element["image_url"];
              }
            });
        });

      }
      
    } on PlatformException catch (err) {
      var message = "An error occures, please check your credentials!";

      if(err.message != null){
        message = err.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Theme.of(context).errorColor,),);
    } catch (err) {
      print(err);
    }
    return retVal;
  }

  Future<void> updateUserData(String username, int age, double height, double weight, double minutes, String whichGender, String whichExeLvl, String userid)async{
    //update data here
    _username = username;
    _gender = whichGender;
    _age = age;
    _weight = weight;
    _height = height;
    _exerciseduration = minutes;
    _exerciselevel = whichExeLvl;
    
    Firestore.instance.collection("users").document(userid).updateData({
      "username": username,
      "gender": whichGender,
      "age": age,
      "weight": weight,
      "height": height,
      "exercise_duration": minutes,
      "exercise_level": whichExeLvl,
    });
  }

  Future<bool> updateImg(String oldUrl, File image, String userid)async{
    bool checking = false;
    if(image!=null){
      checking = true;
      try{
        //delete image
        StorageReference oldRef = await FirebaseStorage().getReferenceFromUrl(oldUrl);
        oldRef.delete();
        //add image
        final ref = FirebaseStorage.instance.ref().child("userImage").child(userid + ".jpg");
        await ref.putFile(image).onComplete;
        final url = await ref.getDownloadURL();
        
        //update data here
        _image = url;
        
        Firestore.instance.collection("users").document(userid).updateData({
          "image_url": url,
        });
        
        checking = false;
    
      }catch(e){
        print(e);
        checking = false;
      }
      
    }
    return checking;
  }
}