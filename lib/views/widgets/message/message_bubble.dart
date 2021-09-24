import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  MessageBubble(this.message,this.isMe);
  @override
  Widget build(BuildContext context) {
    return Row(
      
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.black12 : kGreenColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              )
            ),
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            margin: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: Text(
              message,
              maxLines: 2000,
              style: TextStyle(
                color: isMe ? Colors.black : kWhiteColor,
              ),
              textAlign: isMe ? TextAlign.end : TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }
}