import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/providers/all_user.dart';

class PostWidget extends StatefulWidget {
  final AllUser allUser;
  final List getDoc;
  PostWidget(this.getDoc,this.allUser);
  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.getDoc.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: ((MediaQuery.of(context).size.width / 3) / ((MediaQuery.of(context).size.height - kToolbarHeight - 24) / (MediaQuery.of(context).orientation == Orientation.landscape ? 1.5 : 5))),
        maxCrossAxisExtent: 150,
        crossAxisSpacing: 10,
      ), 
      itemBuilder: (ctx,i){
        return GestureDetector(
          onTap: (){
            for(Map<String,dynamic> d in widget.allUser.users){
              if(d["user_id"] == widget.getDoc[i]["user_id"]){
                Navigator.of(context).pushNamed("/info", arguments: [widget.getDoc[i],d]);
              }
            }
          },
          child: Image.network(widget.getDoc[i]["image_url"], fit:BoxFit.cover)
        );
      },
    );
  }
}