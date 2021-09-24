import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/chat.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_chat.dart';
import 'package:healthy_lifestyle_app/views/widgets/message/input_message.dart';
import 'package:healthy_lifestyle_app/views/widgets/message/message_bubble.dart';
import 'package:provider/provider.dart';

class ChattingScreen extends StatefulWidget {
  final Chat theChat;
  final Map<String,dynamic> data;
  ChattingScreen(this.theChat, this.data);
  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  @override
  Widget build(BuildContext context) {
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    UserChat userchat = Provider.of<UserChat>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(icon: Icon(Icons.navigate_before, color: Colors.black,), onPressed: (){Navigator.of(context).pushNamed("/msg");}),
        title: 
          Text(widget.data["username"], style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.theChat == null? Container() :
            ListView.builder(
              reverse: true,
              itemCount: widget.theChat.conversations.length,
              itemBuilder: (ctx, i){
                return MessageBubble(widget.theChat.conversations[widget.theChat.conversations.length-i-1]["message"], widget.theChat.conversations[widget.theChat.conversations.length-i-1]["user_id"] == userinfo.userId);
              }     
            )
          ),
          InputMessage(userchat, userinfo, widget.data, widget.theChat), 
        ],
      ),
    );
  }
}