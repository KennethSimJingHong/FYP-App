import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class ExerciseCard extends StatefulWidget {
  final List data;
  ExerciseCard(this.data);
  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: widget.data.length ?? 0,
      itemBuilder: (ctx,i){
        return  Text(widget.data[i], style: TextStyle(fontSize: 14, color: kWhiteColor, fontWeight: FontWeight.bold),);
      },
    );
  }
}