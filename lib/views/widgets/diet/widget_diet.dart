import 'package:flutter/material.dart';


Widget gradientBox(BuildContext context, String val){
  return Container(
    width:MediaQuery.of(context).size.width/2 + 50,
    height:50,
    decoration: BoxDecoration(
      borderRadius: (val == "top") ? BorderRadius.only(topLeft:Radius.circular(20)) : BorderRadius.only(bottomLeft:Radius.circular(20)),
      gradient: LinearGradient(
        begin: (val == "top") ? Alignment.topCenter : Alignment.bottomCenter,
        end: (val == "top") ? Alignment.bottomCenter : Alignment.topCenter,
        colors: [Colors.white, Colors.white.withOpacity(0.2)],
      ),
    ),
  );
}