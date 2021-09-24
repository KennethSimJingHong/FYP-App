
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/providers/all_user.dart';
import 'package:healthy_lifestyle_app/views/widgets/sharing/post_widget.dart';
import 'package:provider/provider.dart';

class ShowPostList extends StatefulWidget {
  final int selectedIndex;
  ShowPostList(this.selectedIndex);
  @override
  _ShowPostListState createState() => _ShowPostListState();
}

class _ShowPostListState extends State<ShowPostList> {

  @override
  Widget build(BuildContext context) { 
    AllUser usersinfo = Provider.of<AllUser>(context);
    usersinfo.retrieveUsers();
    
    return StreamBuilder(
      stream: Firestore.instance.collection("posts").orderBy("createdAt",descending: true).snapshots(),
      builder: (ctx,snapShot){
        if(snapShot.hasData){
          final docs = snapShot.data.documents;
          List getDoc = [];
          String selectedIndexVal;
          widget.selectedIndex == 0 ? selectedIndexVal = "Recipe" : widget.selectedIndex == 1 ? selectedIndexVal = "Exercise" : selectedIndexVal = "Default";
          for(DocumentSnapshot d in docs){
            if(d["category"] == selectedIndexVal){
              getDoc.add(d);
            }
          }

          return getDoc.isEmpty ?
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/img/nopost.png", width: double.infinity,),
                Text("There is no post yet!", style: TextStyle(fontSize: 20),)
              ],
            ),
          )
  
          : 
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: getDoc.length,
              itemBuilder: (ctx,i){
                for(Map<String,dynamic> d in usersinfo.users){
                  if(d["user_id"] == getDoc[i]["user_id"]){
                    return PostWidget(getDoc[i], d);
                  }
                }
                return Container();
              }
            ),
          );
        }
        return Container();
      }
    ); 
  }
}

