import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/all_user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/fade_animation.dart';
import 'package:healthy_lifestyle_app/views/widgets/profile/post_widget.dart';
import 'package:provider/provider.dart';

class FavSection extends StatefulWidget {
  @override
  _FavSectionState createState() => _FavSectionState();
}

class _FavSectionState extends State<FavSection> {
  @override
  Widget build(BuildContext context) {
    AllUser allUser = Provider.of<AllUser>(context);
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    return FadeAnimation(.2,"y",
      StreamBuilder(
        stream: Firestore.instance.collection("posts").snapshots(),
        builder: (ctx,snapShot){
          if(snapShot.hasData){
            final docs = snapShot.data.documents;
            List getDoc = [];
            for(DocumentSnapshot d in docs){
              if(d["who_have_liked"].contains(userinfo.userId) && d["user_id"] != userinfo.userId){
                getDoc.add(d);
              }
            }
              return PostWidget(getDoc,allUser);
            
          }
          return Container();
        }
      ),
    );
  }
}