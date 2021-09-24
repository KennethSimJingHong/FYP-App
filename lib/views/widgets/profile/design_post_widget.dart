import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class DesignPostWidget extends StatefulWidget {
  final List<Map<String,dynamic>> data;
  final String typeWidget;
  final List<Color> colors;
  DesignPostWidget(this.data, this.typeWidget, this.colors);
  @override
  _DesignPostWidgetState createState() => _DesignPostWidgetState();
}

class _DesignPostWidgetState extends State<DesignPostWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: widget.typeWidget == "My Post" ? 20 : 5, top:5, bottom: 2, right: widget.typeWidget == "My Post" ? 5 : 20),
      height:100,
      width:MediaQuery.of(context).size.width /2,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0.0,2.0),
            color: Colors.black26,
          ),
        ],
        border: Border.all(width:2, color:kWhiteColor),
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.colors,
        )
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top:20, left:20, bottom:5),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(widget.typeWidget, style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "Roboto", letterSpacing: 1)),
          ),
          Text("${widget.data.length}", style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 30, fontFamily: "RobotoSlab", letterSpacing: 1))
        ],
      ),
    );
  }
}