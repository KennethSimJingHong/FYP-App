import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/calorie.dart';
import 'package:healthy_lifestyle_app/providers/user_food_intake.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShowCalorieList extends StatefulWidget {
  final getDoc;
  ShowCalorieList(this.getDoc);
  @override
  _ShowCalorieListState createState() => _ShowCalorieListState();
}

class _ShowCalorieListState extends State<ShowCalorieList> {
  var formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    UserFoodIntake foodintake = Provider.of<UserFoodIntake>(context);
    final list = widget.getDoc[0]["list"].where((data){
      return data["date"] == formattedDate;
    }).toList();

    return ListView.builder(
      itemCount: list.length,
      itemExtent: 36,
      itemBuilder: (ctx,i){
        if(list[i]["date"] == formattedDate) {
          return ListTile(
          dense: true,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_fire_department, color: kGreenColor,),
              SizedBox(width:3),
              Text(list[i]["title"], style:TextStyle(fontWeight: FontWeight.w500, fontSize: 14),), 
            ],
          ),
          title: Text("(${list[i]["calorie"].toStringAsFixed(0)} CAL)", style: TextStyle(color: kGreyColor, fontSize: 12, fontWeight: FontWeight.w500,)),
          trailing: IconButton(icon:Icon(Icons.delete), color: kRedColor, onPressed: (){
            Calorie cal = new Calorie("",list[i]["title"], list[i]["calorie"], list[i]["date"]);
            foodintake.deleteFood(list[i]["calorie_id"], cal);
          },),
        );
        }
        return Container();
      }
    );
  }
}