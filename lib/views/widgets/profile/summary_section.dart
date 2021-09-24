import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/chart.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/fade_animation.dart';
import 'package:healthy_lifestyle_app/views/widgets/profile/build_bar_chart.dart';
import 'package:healthy_lifestyle_app/views/widgets/profile/exercise_chart.dart';
import 'package:provider/provider.dart';

class SummarySection extends StatefulWidget {
  @override
  _SummarySectionState createState() => _SummarySectionState();
}

class _SummarySectionState extends State<SummarySection> {
  int selectedIndex = 0;
  List<List> datalist;
  DateTime currentDate, startDate, endDate;
  int weekcount = 0; // get to other week


  List<List> exerciseList(){
    return [[],[],[],[],[],[],[]];
  }


  void changeIndex(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  void getDate(int count){
    //show today date, first day of this week, & last day of this week
    currentDate = new DateTime.now();
    startDate = currentDate.subtract(Duration(days: currentDate.weekday - 1 - count));
    endDate = startDate.add(Duration(days:6));
  }

  double updateMaxY(List<Chart> maplist, double maxY){
    maplist.forEach((e) {
      if(maxY == 0){maxY = e.y.toDouble();}
      if(maxY <= e.y){maxY = e.y.toDouble();}
    });
    return maxY;
  }

  double getInterval(double maxY){
    if(maxY >= 1000) return 1000.0;
    if(maxY >= 500) return 500.0;
    if(maxY >= 200) return 200.0;
    if(maxY >= 100) return 100.0;
    if(maxY >= 50) return 50.0;
    if(maxY >= 10) return 10.0;
    return 100.0;
  }

  @override
  Widget build(BuildContext context) {
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    datalist = exerciseList();
    //getting the dates from the specific week range
    getDate(weekcount);

    return FadeAnimation(0.2,"y",
      Column(
        children: [
          SizedBox(height:10),
          Container(
            width: double.infinity,
            height:50,
            margin: EdgeInsets.symmetric(vertical:10, horizontal:30),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(0.0,2.0),
                  color: Colors.black26,
                ),
              ],
              borderRadius: BorderRadius.circular(20),
              color: kWhiteColor
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(customBorder: new CircleBorder(),
                  child: new Icon(
                      Icons.arrow_back,
                      size: 24,
                  ),
                  onTap: () {setState(() {
                    weekcount-=7;
                  });},
                ),
                
                Text("${startDate.toString().split(" ")[0]}  -  ${endDate.toString().split(" ")[0]}", style: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.bold, fontSize: 16),),
                InkWell(customBorder: new CircleBorder(),
                  child: weekcount == 0 ? Container() : Icon(
                      Icons.arrow_forward,
                      size: 24,
                  ),
                  onTap: () {setState(() {
                    weekcount+=7;
                  });},
                ),
              ],
            ),
          ),
          BuildBarChart("water", userinfo.userId, "water_id", "height", startDate, endDate, updateMaxY, getInterval),
          BuildBarChart("foods", userinfo.userId, "calorie_id", "calorie", startDate, endDate, updateMaxY, getInterval),
          BuildBarChart("sleep", userinfo.userId, "sleep_id", "duration", startDate, endDate, updateMaxY, getInterval),
          
          FutureBuilder(
          future: Firestore.instance.collection("exercise").getDocuments(),
          builder: (ctx, snapShot){
            if(snapShot.hasData){
              snapShot.data.documents.forEach((element){
                if(element.documentID == userinfo.userId){
                  if(element["date"] != null){
                    element["date"].forEach((e){
                      DateTime parsedDate = DateTime.parse(e["date"] + ' 00:00:00.000');
                      if( 
                        (new DateTime(startDate.year, startDate.month, startDate.day).isBefore(parsedDate) ||
                        new DateTime(startDate.year, startDate.month, startDate.day).isAtSameMomentAs(parsedDate)) &&
                        (new DateTime(endDate.year, endDate.month, endDate.day).isAfter(parsedDate) ||
                        new DateTime(endDate.year, endDate.month, endDate.day).isAtSameMomentAs(parsedDate))
                      ){
                        if(!datalist[parsedDate.day-startDate.day].contains(e["title"]))
                          datalist[parsedDate.day-startDate.day].add(e["title"]);
                      }
                    });
                  }
                }
              });
              return ExerciseChart(datalist, startDate);
            }
            return Container();
          }),
        ],
      ),
    );
  }
}