import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/providers/user_post.dart';
import 'package:provider/provider.dart';

class DeletePostDialog extends StatefulWidget {
  final String postid;
  final String url;
  DeletePostDialog(this.postid, this.url);
  @override
  _DeletePostDialogState createState() => _DeletePostDialogState();
}

class _DeletePostDialogState extends State<DeletePostDialog> {

  @override
  Widget build(BuildContext context) {
    UserPost userPost = Provider.of<UserPost>(context);
    return AlertDialog(
      title: Text("Delete The Post"),
      content: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              child: Text("Confirm", style: TextStyle(color: kWhiteColor),),
              style: ElevatedButton.styleFrom(primary:kGreenColor),
              onPressed: (){
                userPost.deletePost(widget.postid, widget.url);
                Navigator.of(context).pop();
              },
            ),
          ),
          SizedBox(width:10),
          Expanded(
            child: ElevatedButton(
              child: Text("Cancel", style: TextStyle(color: kWhiteColor),),
              style: ElevatedButton.styleFrom(primary:kRedColor),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<Widget> deletePostDialog (BuildContext context, String docid, String url)async{
  return await showDialog(
    context: context,
    builder: (_) => Center(child: SingleChildScrollView(child: DeletePostDialog(docid, url))),
  );
}