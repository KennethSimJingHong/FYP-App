import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/models/chart.dart';
import 'package:healthy_lifestyle_app/views/widgets/profile/bar_chart.dart';

class BuildBarChart extends StatefulWidget {
  final String collection, userid, collectionuid, dataToPass;
  final DateTime startDate, endDate;
  final Function updateMaxY, getInterval;
  BuildBarChart(this.collection, this.userid, this.collectionuid, this.dataToPass, this.startDate, this.endDate, this.updateMaxY, this.getInterval);
  @override
  _BuildBarChartState createState() => _BuildBarChartState();
}


class _BuildBarChartState extends State<BuildBarChart> {
  List<Chart> listData;

  List<Chart> weeklyData(){
    return [new Chart(1,"Mon"), new Chart(2,"Tue"), new Chart(3,"Wed"), new Chart(4,"Thu"), new Chart(5,"Fri"), new Chart(6,"Sat"), new Chart(7,"Sun")];
  }

  void createChart(List<dynamic> maplist, List<Chart> datalist, String data,String id, String userid, DateTime start, DateTime end){
    // variable for accumulate cal for foods only
    double food = 0;
    double sleep = 0;
    String date;

    maplist.forEach((i) {
      DateTime parsedDate = DateTime.parse( data == "duration" ? (i["sleep_datetime"].toString().split(" ")[0] + ' 00:00:00.000') : (i["date"] + ' 00:00:00.000'));
      if( 
        (new DateTime(start.year, start.month, start.day).isBefore(parsedDate) ||
        new DateTime(start.year, start.month, start.day).isAtSameMomentAs(parsedDate)) &&
        (new DateTime(end.year, end.month, end.day).isAfter(parsedDate) ||
        new DateTime(end.year, end.month, end.day).isAtSameMomentAs(parsedDate))
      ){
        if(userid == i[id]){
          if(parsedDate.day < start.day){
            
            if(data == "calorie" && (date == null || date != i["date"])){
              food = 0;
              date = i["date"];
              food += i[data];
            }else if(data == "calorie" && date == i["date"]){
              food += i[data];
            }
          
            if(data == "duration" && (date == null || date != i["sleep_datetime"].split(" ")[0])){
              sleep = 0;
              date = i["sleep_datetime"].split(" ")[0];
              sleep += i[data];
              print(i["sleep_datetime"].split(" ")[0]);
            }else if(data == "duration" && date == i["sleep_datetime"].split(" ")[0]){
              sleep += i[data];
            }

            datalist[parsedDate.day + DateUtil().daysInMonth(parsedDate.month,parsedDate.year) - start.day -1].y = data == "calorie" ? food : data == "duration" ? sleep : double.parse(i[data].toString());
          }else{
            

            if(data == "calorie" && (date == null || date != i["date"])){
              food = 0;
              date = i["date"];
              food += i[data];
            }else if(data == "calorie" && date == i["date"]){
              food += i[data];
            }

            if(data == "duration" && (date == null || date != i["sleep_datetime"].split(" ")[0])){
              sleep = 0;
              date = i["sleep_datetime"].split(" ")[0];
              sleep += i[data];
              print(i["sleep_datetime"].split(" ")[0]);
            }else if(data == "duration" && date == i["sleep_datetime"].split(" ")[0]){
              sleep += i[data];
            }


            datalist[parsedDate.day-start.day].y = data == "calorie" ? food : data == "duration" ? sleep : double.parse(i[data].toString());
          }
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    listData = weeklyData();
    return FutureBuilder(
      future: Firestore.instance.collection(widget.collection).getDocuments(),
      builder: (ctx, snapShot){
        if(snapShot.hasData){

          snapShot.data.documents.forEach((element){
              createChart(element["list"], listData, widget.dataToPass, widget.collectionuid, widget.userid, widget.startDate, widget.endDate);
          });
          


          if(widget.collection == "water")
          return ProfileBarChart([Color(0xFFF3C080),Color(0xFFF09118)], "Hydration Intake", listData, widget.updateMaxY, widget.getInterval);
          if(widget.collection == "foods")
          return ProfileBarChart([Color(0xFF72BAE9),Color(0xFF1796EA)], "Calorie Intake", listData, widget.updateMaxY, widget.getInterval);
          if(widget.collection == "sleep")
          return ProfileBarChart([Color(0xFFC186D9),Color(0xFF9756B2)], "Sleep Duration", listData, widget.updateMaxY, widget.getInterval);

        } 
        return Container();
      }
    );
  }
}