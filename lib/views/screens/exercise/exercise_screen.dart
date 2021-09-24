import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_exerise_program.dart';
import 'package:healthy_lifestyle_app/views/widgets/exercise/add_exercise_dialog.dart';
import 'package:healthy_lifestyle_app/views/widgets/exercise/pedometer.dart';
import 'package:healthy_lifestyle_app/views/widgets/exercise/show_exercise_list.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/fade_animation.dart';
import 'package:provider/provider.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  bool isManage = false;



  @override
  Widget build(BuildContext context) {
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    final exerciseProgram = Provider.of<UserExerciseProgram>(context);
    exerciseProgram.exerciseList(userinfo.userId);
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [  
              FadeAnimation(1,"y",
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    children: [
                      Text("Exercise", 
                        style:TextStyle(
                          fontFamily: "RobotoSlab",
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                        Text(" Plan", 
                        style:TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.normal,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              FadeAnimation(1.2,"y",
                Column(
                  children: [
                    PedometerWidget(),
                    SizedBox(height:30),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Exercise", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "RobotoSlab"),),
                                      Text("Programme", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: "RobotoSlab"),),
                                    ],
                                  ),
                                  TextButton( 
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.only(bottom:6)
                                    ),
                                    child: Text("Edit", style: TextStyle(color: Colors.black45, fontSize: 18),),
                                    onPressed: (){ setState(() {
                                      isManage = !isManage;
                                    });},),
                                ],
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                                  primary: kGreenColor, 
                                ),
                                
                                icon: Icon(Icons.add_outlined, color: kWhiteColor,), 
                                label: Text("Add Exercise", style: TextStyle(color: kWhiteColor),),
                                onPressed: (){
                                  addExerciseDialog(context);
                                }
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      padding: EdgeInsets.only(top:20),
                      height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height * 0.50),
                      width: double.infinity,
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: kWhiteColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            offset: Offset(0.0,2.0),
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      
                      child: Column(
                        children: [
                          Text("What exercise have you done today?", style: TextStyle(fontSize: 12),),
                          Expanded(
                            child: StreamBuilder(
                              stream: Firestore.instance.collection("exercise").snapshots(),
                              builder: (ctx, snapShot){
                                if(snapShot.hasData){
                                  final getDoc = snapShot.data.documents.where((doc) => doc.documentID == userinfo.userId).toList();
                                  if(getDoc.isNotEmpty){
                                    if(getDoc[0]["list"].isNotEmpty){
                                      return Container(
                                        child: ShowExerciseList(getDoc, isManage),
                                      );
                                    }else return Center(child: Image.asset("assets/img/empty.png"));
                                  }else return Center(child: Image.asset("assets/img/empty.png"));
                                
                                }
                                return Container();
                              }
                            ),
                          ),
                        ],
                      ),
                    
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}