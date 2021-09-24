import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/views/widgets/message/message_list.dart';


class MessengerProcessing extends StatelessWidget {
  final List<Map<String,dynamic>> datalist;
  MessengerProcessing(this.datalist);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: datalist.length,
      itemBuilder: (ctx,i){
        return MessageList(datalist[i],lastMessage: datalist[i]["messages"][datalist[i]["messages"].length-1]["message"]);
      }
    );
  }
}