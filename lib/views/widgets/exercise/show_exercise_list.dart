import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/exercise.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_exerise_program.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShowExerciseList extends StatefulWidget {
  final getDoc;
  final bool isManage;
  ShowExerciseList(this.getDoc, this.isManage);
  @override
  _ShowExerciseListState createState() => _ShowExerciseListState();
}

class _ShowExerciseListState extends State<ShowExerciseList> {

  void checking(List main, List check){
    var formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    main.forEach((element) {
      for(int i = 0; i < check.length; i++){
        if(check[i]["title"] == element["title"] && check[i]["description"] == element["description"] && check[i]["date"] == formattedDate){
          element["status"] = true;
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    List list = widget.getDoc[0]["list"] ?? [];
    List lst = widget.getDoc[0]["date"] ?? [];
    checking(list,lst);
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    final exerciseProgram = Provider.of<UserExerciseProgram>(context);
    return ListView.builder(
      itemExtent: 50,
      itemCount: list.length ?? 0,
      itemBuilder: (ctx, i){
        return CheckboxListTile(
          secondary: widget.isManage ? IconButton(icon: Icon(Icons.delete, color: kRedColor,), onPressed: (){
            exerciseProgram.deleteExercise(userinfo.userId, new Exercise("", list[i]["title"], list[i]["description"], list[i]["duration"], list[i]["status"]));
          }) : null,
          title: Text(list[i]["title"]),
          subtitle: Text(list[i]["description"] + " - " + list[i]["duration"]),
          value: list[i]["status"],
          onChanged: (val){
            setState(() {
              list[i]["status"] = !list[i]["status"];  
              if(list[i]["status"]){
                exerciseProgram.updateTodayExercise(
                  userinfo.userId, 
                  new Exercise("", list[i]["title"], list[i]["description"], list[i]["duration"],true),
                );
              }else{
                exerciseProgram.removeTodayExercise(
                  userinfo.userId, 
                  new Exercise("", list[i]["title"], list[i]["description"], list[i]["duration"],false),
                );
              }      
            });
          },
        );
      },
    );
  }
}