import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/all_user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/fav_button.dart';
import 'package:healthy_lifestyle_app/views/widgets/sharing/delete_post_dialog.dart';
import 'package:healthy_lifestyle_app/views/widgets/sharing/report_dialog.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatefulWidget {
  final Map<String,dynamic> d;
  final getDoc;
  PostWidget(this.getDoc, this.d);
  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {



  @override
  Widget build(BuildContext context) {
    User userInfo = Provider.of<CurrentUser>(context).currentUserInfo;
    AllUser allUser = Provider.of<AllUser>(context);
    DateTime currentdatetime = new DateTime.now();
    DateTime postTime = DateTime.fromMicrosecondsSinceEpoch(widget.getDoc["createdAt"].microsecondsSinceEpoch);
    final durationInMinutes = currentdatetime.difference(postTime).inMinutes;
    final durationInHours = currentdatetime.difference(postTime).inHours;
    final durationInDays = currentdatetime.difference(postTime).inDays; 

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width:double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.d["image_url"]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.d["username"], style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(durationInDays >= 1 ? 
                            (durationInDays == 1 ? "$durationInDays day ago" : "$durationInDays days ago")
                            : durationInHours >= 1 ? (durationInHours == 1 ? "$durationInHours hour ago" :"$durationInHours hours ago") 
                            : durationInMinutes >= 1 ? (durationInMinutes == 1 ? "$durationInMinutes minute ago" : "$durationInMinutes minutes ago") 
                            : "Few seconds ago", style: TextStyle(color: Colors.black87, fontSize: 11),),
                        ],
                      ),
                    ),
                  ],
                ), 
                IconButton(icon: Icon(Icons.more_vert_outlined), onPressed: (){
                  widget.d["user_id"] == userInfo.userId ?
                  showAdaptiveActionSheet(
                    context: context,
                    actions: <BottomSheetAction>[
                        BottomSheetAction(title:
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.report_problem_outlined, color: kRedColor,),
                             SizedBox(width:10),
                             Text('Report', style: TextStyle(color: kRedColor),),
                           ],
                         ), 
                         onPressed: () {Navigator.of(context).pop();reportDialog(context, widget.getDoc["post_id"]);}
                        ),

                        
                        BottomSheetAction(title:
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.delete_forever_outlined, color: kRedColor,),
                             SizedBox(width:10),
                             Text('Delete', style: TextStyle(color: kRedColor),),
                           ],
                         ), 
                         onPressed: () {Navigator.of(context).pop();deletePostDialog(context, widget.getDoc["post_id"], widget.getDoc["image_url"]);}
                        )
                    ],
                    cancelAction: CancelAction(title: const Text('Cancel', style: TextStyle(color:kGreenColor),),),// onPressed parameter is optional by default will dismiss the ActionSheet
                  ):
                  showAdaptiveActionSheet(
                    context: context,
                    actions: <BottomSheetAction>[
                      BottomSheetAction(title:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.report_problem_outlined, color: kRedColor,),
                            SizedBox(width:10),
                            Text('Report', style: TextStyle(color: kRedColor),),
                          ],
                        ), 
                        onPressed: () {Navigator.of(context).pop();reportDialog(context, widget.getDoc["post_id"]);}
                      ),
                    ],
                    cancelAction: CancelAction(title: const Text('Cancel', style: TextStyle(color:kGreenColor),),),// onPressed parameter is optional by default will dismiss the ActionSheet
                  );
                }),
              ],
            ),    
            
            SizedBox(height:10),

              GestureDetector(
                child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                          widget.getDoc["image_url"],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                      ),
                  ),
                  Container(
                    height:50,
                    width:50,
                    decoration: BoxDecoration(
                      color: kWhiteColor.withOpacity(.5),
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(8), topLeft: Radius.circular(8))
                    ),
                    child: Icon(Icons.article_outlined,),
                  ),

                ],
              ),
              onTap: (){
                Navigator.of(context).pushNamed("/info", arguments: [widget.getDoc,widget.d]);
              },
              
            ),

            Padding(
              padding: const EdgeInsets.all(2.0),
              child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width:MediaQuery.of(context).orientation == Orientation.landscape ? MediaQuery.of(context).size.width - 220 : MediaQuery.of(context).size.width - 130,
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height:3),
                            Text(widget.getDoc["title"], style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                            Text("${widget.getDoc["who_have_liked"].length}" "${widget.getDoc["who_have_liked"].length <= 1 ? " like" : " likes"}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),),
                            SizedBox(height:3),
                            StreamBuilder(
                              stream: Firestore.instance.collection("comments").snapshots(),
                              builder: (ctx, snapShot){
                                if(snapShot.hasData){
                                  var comment;
                                  var firstUser;
                                  snapShot.data.documents.forEach((element){
                                    if(element["comment_list"].length != 0){
                                      if(element["comment_id"] == widget.getDoc["post_id"]){
                                        comment = element;
                                      }
                                    }else{
                                      comment = null;
                                    }
                                  });

                                  if(comment != null)
                                  allUser.users.forEach((user){
                                    if(user["user_id"] == comment["comment_list"][0]["user_id"]){
                                      firstUser = user;
                                    }
                                  });
                                  return 
                                  comment == null ?
                                  GestureDetector(child: Text("Be the first to comment!", style: TextStyle(fontSize: 15, color: Colors.black54),), onTap: (){Navigator.of(context).pushNamed("/comment", arguments: widget.getDoc["post_id"]);},):
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(color: Colors.black,fontSize: 16),
                                          children: [
                                            comment["comment_list"].length != 0 ? TextSpan(text:"${firstUser["username"]}  ", style: TextStyle(fontWeight: FontWeight.w700)) : Container(),
                                            comment["comment_list"].length != 0 ? TextSpan(text:comment["comment_list"][comment["comment_list"].length-1]["comment_text"]) : Container(),
                                          ]
                                        )
                                      ),
                                      GestureDetector(onTap: (){Navigator.of(context).pushNamed("/comment", arguments: widget.getDoc["post_id"]);}, child: comment["comment_list"].length == 0 ? Text("Be the first to comment!", style: TextStyle(fontSize: 15, color: Colors.black54),) : comment["comment_list"].length == 1 ? Text("View all ${comment["comment_list"].length} comment", style: TextStyle(fontSize: 15, color: Colors.black54),) : Text("View all ${comment["comment_list"].length} comments", style: TextStyle(fontSize: 15,color: Colors.black54),))
                                    ],
                                  );
                                }return Container();
                              }
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(icon: Icon(Icons.comment_rounded, color: Colors.black26,), splashRadius: 25.0, onPressed: (){Navigator.of(context).pushNamed("/comment", arguments: widget.getDoc["post_id"]);}),
                            FavButton(widget.getDoc),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                
            ),
            
          ],
        )
      ),
    ); 
  }
}