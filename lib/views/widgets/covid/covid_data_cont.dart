import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class CovidDataCont extends StatefulWidget {
  final Color color;
  final String detail;
  final int data;
  CovidDataCont(this.color, this.detail, this.data);
  @override
  _CovidDataContState createState() => _CovidDataContState();
}

class _CovidDataContState extends State<CovidDataCont> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset:Offset(0.0, 3.0),
                blurRadius: 6.0,
              ),
            ]
          ),
        ),

        Column(
          children: [
            Text(
              "${widget.detail}",
              style: TextStyle(
                fontFamily: "RobotoSlab",
                color: kWhiteColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height:20),
            Text(
              "${widget.data}",
              style: TextStyle(
                fontFamily: "Roboto",
                color: kWhiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        
      ],
    );
  }
}