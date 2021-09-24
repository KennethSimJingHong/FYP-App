
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/models/chat.dart';

class UserChat with ChangeNotifier{
  String _cid;
  List _users;
  List<dynamic> _conversations;

  get userChatInfo{
    return Chat(_cid, _users, _conversations);
  }
  
  //add message
  Future<void> addMessage(Chat theChat, String uid, String message, String uid2) async{
    if(theChat != null){
      _conversations = theChat.conversations;
      _conversations.add({"message": message, "user_id": uid});
      Firestore.instance.collection("chats").document(theChat.chatId).updateData({
        "messages":_conversations,
      });
    }else{
      DocumentReference docRef = Firestore.instance.collection("chats").document();
      docRef.setData({
        "chat_id":docRef.documentID,
        "messages":[{"message": message, "user_id": uid}],
        "users":[uid, uid2],
      });
    }
  }
}