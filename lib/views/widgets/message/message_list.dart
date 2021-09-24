import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class MessageList extends StatelessWidget {
  final Map<String,dynamic> data;
  final String lastMessage;
  MessageList(this.data,{this.lastMessage = "noconversationstartedyet"});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: ListTile(
          onTap: (){
            Map<String,dynamic> d = data;
            Navigator.of(context).pushNamed("/chat", arguments: d);
          },
          contentPadding: EdgeInsets.all(5),
          tileColor: kWhiteColor,
          leading: CircleAvatar(backgroundImage: NetworkImage(data["image_url"]), radius: 25,),
          title: Text(data["username"], style: TextStyle(fontWeight: FontWeight.w600),),
          subtitle:lastMessage == "noconversationstartedyet" ? null : Text(lastMessage),
        ),
      ),
    );
  }
}