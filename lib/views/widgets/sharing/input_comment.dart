import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/comment.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_post.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InputComment extends StatefulWidget {
  final UserPost userPost;
  final Comment comment;
  InputComment(this.userPost, this.comment);
  @override
  _InputCommentState createState() => _InputCommentState();
}

class _InputCommentState extends State<InputComment> {
  var formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  final _controller = new TextEditingController();
  var _enteredMessage = "";

  void _sendMessage(UserPost userPost, String uid){

    Comment newComment = widget.comment;
    if(newComment.comment == null){
      newComment.comment = [{"comment_text": _enteredMessage, "user_id" : uid, "createdAt": Timestamp.now(),}];
    }else{
      newComment.comment.add({"comment_text": _enteredMessage, "user_id" : uid, "createdAt": Timestamp.now(),});
    }
    FocusScope.of(context).unfocus();
    userPost.commentPost(newComment);
    _controller.clear();
    _enteredMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    User userInfo = Provider.of<CurrentUser>(context).currentUserInfo;
    return Row(
      children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "Add a comment", border: InputBorder.none), onChanged: (val){ setState(() {
            _enteredMessage = val;
          });  },),
        )),
        IconButton(icon: Icon(Icons.send_sharp, color: _enteredMessage.trim().isEmpty ? null : kGreenColor,), onPressed: _enteredMessage.trim().isEmpty ? null : (){_sendMessage(widget.userPost, userInfo.userId);}),
      ],
    );
  }
}