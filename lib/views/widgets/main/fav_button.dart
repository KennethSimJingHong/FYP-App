import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_post.dart';
import 'package:provider/provider.dart';

class FavButton extends StatefulWidget {
  final getDoc;
  FavButton(this. getDoc);
  @override
  _FavButtonState createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> with SingleTickerProviderStateMixin{

  bool checkStatus(List dataList, String userid){
    return dataList.contains(userid) ? true : false;
  }

  AnimationController scaleAnimationController;

  @override
  void initState() {
    scaleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 125),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.5,
    );
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserPost userpost  = Provider.of<UserPost>(context);
    User userinfo = Provider.of<CurrentUser>(context).currentUserInfo;
    
    return InkWell(
      customBorder: CircleBorder(),
      onTap: () => _onTap(userpost, userinfo.userId),
      child: Container(
        width:50,
        height:50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: ScaleTransition(
          scale: scaleAnimationController,
          child: Icon(Icons.favorite,
            size: 25,
            color: checkStatus(widget.getDoc["who_have_liked"], userinfo.userId) ? kRedColor : Colors.black26
          ),
        ),
      ),
    );
  }


  void _onTap(UserPost userpost, String uid){
    scaleAnimationController.forward().then((value){ 
      scaleAnimationController.reverse();
      userpost.updatePostFav(widget.getDoc, uid, !checkStatus(widget.getDoc["who_have_liked"], uid));
    });
  }
}


