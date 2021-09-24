import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/chat.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/user_chat.dart';

class InputMessage extends StatefulWidget {
  final UserChat userchat;
  final User userinfo;
  final Map<String,dynamic> data;
  final Chat theChat;
  InputMessage(this.userchat,this.userinfo,this.data, this.theChat);
  @override
  _InputMessageState createState() => _InputMessageState();
}

class _InputMessageState extends State<InputMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = "";

  void _sendMessage(UserChat userchat, User userinfo, Map<String,dynamic> data){
    FocusScope.of(context).unfocus();
    userchat.addMessage(widget.theChat, userinfo.userId, _enteredMessage, data["user_id"]);
    _controller.clear();
    _enteredMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "Send a message", border: InputBorder.none), onChanged: (val){ setState(() {
            _enteredMessage = val;
          });  },),
        )),
        IconButton(icon: Icon(Icons.send_sharp, color: _enteredMessage.trim().isEmpty ? null : kGreenColor,), onPressed: _enteredMessage.trim().isEmpty ? null : (){_sendMessage(widget.userchat, widget.userinfo, widget.data);}),
      ],
    );
  }
}