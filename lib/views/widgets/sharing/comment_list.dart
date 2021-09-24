import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/models/comment.dart';
import 'package:healthy_lifestyle_app/providers/all_user.dart';
import 'package:provider/provider.dart';

class CommentList extends StatefulWidget {
  final Comment data;
  CommentList(this.data,);
  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    AllUser allUser = Provider.of<AllUser>(context);
    return ListView.builder(
      itemCount: widget.data.comment.length,
      itemBuilder: (ctx, i){
        String imageUrl;
        String username;
        allUser.users.forEach((element) {
          if(element["user_id"] == widget.data.comment[i]["user_id"]){
            imageUrl = element["image_url"];
            username = element["username"];
          }
        });

        DateTime currentdatetime = new DateTime.now();
        DateTime postTime = DateTime.fromMicrosecondsSinceEpoch(widget.data.comment[i]["createdAt"].microsecondsSinceEpoch);
        final durationInMinutes = currentdatetime.difference(postTime).inMinutes;
        final durationInHours = currentdatetime.difference(postTime).inHours;
        final durationInDays = currentdatetime.difference(postTime).inDays;


        return Padding(
          padding: const EdgeInsets.symmetric(vertical:5.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(imageUrl),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                RichText(text: TextSpan(
                  style: TextStyle(color: Colors.black, ),
                  children: [
                    new TextSpan(text: "$username  ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                    new TextSpan(text: widget.data.comment[i]["comment_text"]),
                  ]
                )),

                SizedBox(height:3),
                Text(durationInDays >= 1 ? 
                  (durationInDays == 1 ? "$durationInDays day ago" : "$durationInDays days ago")
                  : durationInHours >= 1 ? (durationInHours == 1 ? "$durationInHours hour ago" :"$durationInHours hours ago") 
                  : durationInMinutes >= 1 ? (durationInMinutes == 1 ? "$durationInMinutes minute ago" : "$durationInMinutes minutes ago") 
                  : "Few seconds ago", style: TextStyle(color: Colors.black87, fontSize: 11),),
              ],
            ),
          ),
        );
      },
    );
  }
}