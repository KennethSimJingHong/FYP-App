import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_sleep.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/fade_animation.dart';
import 'package:healthy_lifestyle_app/views/widgets/sleep/add_alarm_dialog.dart';
import 'package:healthy_lifestyle_app/views/widgets/sleep/add_sleep_dialog.dart';
import 'package:healthy_lifestyle_app/views/widgets/sleep/audio_control.dart';
import 'package:healthy_lifestyle_app/views/widgets/sleep/show_alarm_list.dart';
import 'package:provider/provider.dart';

class SleepScreen extends StatefulWidget {
  @override
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  
  bool isManage = false, toChange = false;



  @override
  Widget build(BuildContext context) {
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    UserSleep userSleep = Provider.of<UserSleep>(context);
    userSleep.sleepList(userinfo.userId);
    userSleep.alarmList(userinfo.userId);

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeAnimation(1,"y",
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    children: [
                      Text("Sleep",
                        style: TextStyle(
                          fontFamily: "RobotoSlab",
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Text(" Plan",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.normal,
                          fontSize: 30,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              

              FadeAnimation(1.2, "y",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:30.0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sleep", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "RobotoSlab"),),
                              Text("Daily Tracking", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: "RobotoSlab"),),
                              SizedBox(height:10),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal:25),
                      padding: EdgeInsets.symmetric(vertical: 5),                    
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kGreenColor
                        ),
                        onPressed: (){addSleepDialog(context);}, 
                        child: Text("Record Your Sleep"),
                      ),
                    ),

                    SizedBox(height:30),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("Alarm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "RobotoSlab"),),
                              TextButton( 
                                style: TextButton.styleFrom(
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.only(bottom:6)
                                ),
                                child: Text("Edit", style: TextStyle(color: Colors.black45, fontSize: 18),),
                                onPressed: (){ setState(() {
                                  isManage = !isManage;
                                  toChange = true;
                                });},),
                            ],
                          ),
                        
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                              primary: kGreenColor, 
                            ),
                                
                            icon: Icon(Icons.add_outlined, color: kWhiteColor,), 
                            label: Text("Add Alarm", style: TextStyle(color: kWhiteColor),),
                            onPressed: (){
                              addAlarmDialog(context, userSleep);
                            },
                          )  
                               
                                
                        ],
                      ),     
                    ),
                    SizedBox(height:10),
                    Container(
                      margin: EdgeInsets.only(left:25, right:25, bottom:30),
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      height:250,
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            offset: Offset(0.0,2.0),
                            color:Colors.black26,
                          ),
                        ]
                      ),
                      child: StreamBuilder(
                        stream: Firestore.instance.collection("alarm").snapshots(),
                        builder: (ctx, snapShot){
                          
                          if(snapShot.hasData){
                            final getDoc = snapShot.data.documents.where((doc) => doc.documentID == userinfo.userId).toList();
                            if(getDoc.isNotEmpty){
                              if(getDoc[0]["alarm"].isNotEmpty){
                                return ShowAlarmList(getDoc[0]["alarm"] ?? [], isManage, toChange);
                              }else return Center(child: Image.asset("assets/img/empty.png")); 
                            }else return Center(child: Image.asset("assets/img/empty.png"));
                          }
                          return Container();
                        },
                      )
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:30.0, right:30.0, top: 10),
                      child: 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Music", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "RobotoSlab"),),
                          Text("To Sleep", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: "RobotoSlab"),),
                          SizedBox(height:10),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: Firestore.instance.collection("music").getDocuments(),
                      builder: (ctx, snapShot){
                        if(snapShot.hasData){
                          List<Map<String,String>> items = [];
                          
                          snapShot.data.documents.forEach((element) {                
                              items.add({"title": element.data["music_name"], "url": element.data["music_url"]});
                          });
                          
                          if(items.isNotEmpty)
                          return Container(
                            height:150,
                            child: AudioControl(items)
                          );
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical:20.0),
                            child: Center(child: Text("No music", style: TextStyle(color: Colors.black54, fontSize: 20,))),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                )  
              ),
            ],
          ),
        ),
      ),
    );
  }
}