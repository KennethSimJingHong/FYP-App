import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/views/widgets/profile/exercise_cards.dart';

class ExerciseChart extends StatefulWidget {
  final List datalist;
  final DateTime startDate;
  ExerciseChart(this.datalist,this.startDate);
  @override
  _ExerciseChartState createState() => _ExerciseChartState();
}



class _ExerciseChartState extends State<ExerciseChart> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
      margin:EdgeInsets.symmetric(horizontal:20, vertical:2),
      decoration: BoxDecoration(
        border: Border.all(width:2, color:kWhiteColor),
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF08189),Color(0xFFF03C4A)],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0.0,2.0),
            color: Colors.black26,
          ),
        ],
      ),
      height:200,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top:10, left:10),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            
            child: Text("Exercise Routine", style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "Roboto", letterSpacing: 1)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.datalist.length ?? 0,
              itemBuilder: (ctx,i){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top:2, bottom:2),
                      padding: EdgeInsets.all(2),
                      width:double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color:kWhiteColor),
                        color: kWhiteColor.withOpacity(.2),
                      ),
                      child: Text("${widget.startDate.add(Duration(days:i)).toString().split(" ")[0]}", style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 16),),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExerciseCard(widget.datalist[i]),
                    ),
                  ],
                );
              }
            ),
          ),
        ],
      )
    );
  }
}

