import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/all_user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/views/widgets/message/messenger_processing.dart';
import 'package:healthy_lifestyle_app/views/widgets/message/search_sharing.dart';
import 'package:provider/provider.dart';

class MessengerScreen extends StatefulWidget {
  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  @override
  Widget build(BuildContext context) {
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    List<Map<String, dynamic>> allUser = Provider.of<AllUser>(context, listen: false).users;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){Navigator.of(context).pushNamed("/sharing");}),
        title: Text("Messenger", style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.black,), onPressed: (){
            showSearch(context: context, delegate: SearchSharing());
          }),
        ],
      ),
      body: 
      StreamBuilder(
        stream: Firestore.instance.collection("chats").snapshots(),
        builder: (ctx,snapShot){
          if(snapShot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(snapShot.hasData){
            List<Map<String,dynamic>> datalist = [];

            snapShot.data.documents.forEach((doc){
              if(doc["users"].contains(userinfo.userId)){
                  String uid;
                  if(doc["users"][0] == userinfo.userId){
                    uid = doc["users"][1];
                  }else{uid = doc["users"][0]; }
                  final data = allUser.firstWhere((element) => element["user_id"] == uid);
                  datalist.add({
                    "messages":doc["messages"],
                    "username":data["username"],
                    "image_url":data["image_url"], 
                    "user_id":data["user_id"],
                  });
                }
            });
            if(datalist.isNotEmpty){
              return MessengerProcessing(datalist);
            }

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/img/chat.png", width: double.infinity,),
                    Text("Start a conversation now!", style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
      
      
      
    );
  }
}
