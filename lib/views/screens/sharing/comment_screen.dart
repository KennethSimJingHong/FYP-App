import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/comment.dart';
import 'package:healthy_lifestyle_app/providers/user_post.dart';
import 'package:healthy_lifestyle_app/views/widgets/sharing/comment_list.dart';
import 'package:healthy_lifestyle_app/views/widgets/sharing/input_comment.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  Comment comment = new Comment(null, null, null);
  @override
  Widget build(BuildContext context) {
    final String postId = ModalRoute.of(context).settings.arguments;
    UserPost userPost = Provider.of<UserPost>(context);
    comment.commentid = postId;
    comment.postid = postId;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: Text("Comments", style: TextStyle(color: Colors.black),),
        leading: BackButton(color:Colors.black, onPressed: (){Navigator.of(context).pop();},),
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
              stream: Firestore.instance.collection("comments").snapshots(),
              builder: (context, snapShot){
                if(snapShot.hasData){
                  snapShot.data.documents.forEach((element){
                    if(element["comment_id"] == postId){
                      comment.comment = element["comment_list"];
                    }
                  });
                  return
                  comment.comment != null ?
                  CommentList(comment) :
                  Container();
                }
                return Container();
              },
            )
          ),
          InputComment(userPost,comment),
        ],
      ),
    );
  }
}