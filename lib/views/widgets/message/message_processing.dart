import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/models/chat.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/views/screens/sharing/chatting_screen.dart';
import 'package:provider/provider.dart';

class MessageProcessing extends StatefulWidget {
  @override
  _MessageProcessingState createState() => _MessageProcessingState();
}

class _MessageProcessingState extends State<MessageProcessing> {
  
  @override
  Widget build(BuildContext context) {
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    Map<String,dynamic> data = ModalRoute.of(context).settings.arguments;
    return StreamBuilder(
      stream: Firestore.instance.collection("chats").snapshots(),
      builder: (ctx, snapShot){
        if(snapShot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        
        Chat theChat;
        if(snapShot.hasData){
          snapShot.data.documents.forEach((doc){ 
            if(doc["users"].contains(userinfo.userId) && doc["users"].contains(data["user_id"])){
              theChat = new Chat(doc["chat_id"], doc["users"], doc["messages"]);
            }
          });
        }
        
        return ChattingScreen(theChat, data);
       
      },
    );
  }
}