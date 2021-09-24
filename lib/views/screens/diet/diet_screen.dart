import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/models/water.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_food_intake.dart';
import 'package:healthy_lifestyle_app/providers/user_water_intake.dart';
import 'package:healthy_lifestyle_app/views/widgets/diet/calorie/add_food_dialog.dart';
import 'package:healthy_lifestyle_app/views/widgets/diet/calculate_function.dart';
import 'package:healthy_lifestyle_app/views/widgets/diet/calorie/show_calorie_list.dart';
import 'package:healthy_lifestyle_app/views/widgets/diet/hydration/wave_container.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/fade_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DietScreen extends StatefulWidget {
  @override
  _DietScreenState createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  
  @override
  void initState() {
    super.initState();
      controller = AnimationController(
        duration: Duration(seconds: 1),
        vsync: this)
      ..repeat();
  }
  

  double total = 0;
  void manageWaterCalculation(String manage, Function manageWater, String id){
    if (manage == "add"){
       setState(() {
            total += 240;
        });
    }else if (manage == "remove"){
      if(total >= 240){
        setState(() {
            total -= 240;
        });
      }
    }
    var formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    Water newWater = new Water("",total, formattedDate);
    manageWater(id, newWater);

  }

  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  var formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  countCalorie(){

  }

  @override
  Widget build(BuildContext context) {
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    UserWaterIntake userWaterIntake = Provider.of<UserWaterIntake>(context, listen: false);
    final foodintake = Provider.of<UserFoodIntake>(context);
    foodintake.foodintake(userinfo.userId);
    userWaterIntake.waterintake(userinfo.userId);
    double calorie = calculateCalorie(userinfo);
    double water = calculateHydration(userinfo);
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeAnimation(1, "y",
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    children: [
                      Text("Diet", 
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

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      height:280,
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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: [
                            Text("Standard Dietary Intake", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontFamily: "Roboto", color: Colors.black87),),
                            SizedBox(height:20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.local_dining, size: 35, color: kGreenColor,),
                                    SizedBox(height:10),
                                    Row(
                                      children: [
                                        Text("${calorie.toStringAsFixed(0)}", style: TextStyle(color: kGreenColor, fontWeight: FontWeight.bold, fontFamily: "Roboto", fontSize: 25),),
                                        SizedBox(width:5),
                                        Text("cal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                      ],
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Icon(Icons.local_drink, size: 35,color: kGreenColor,),
                                    SizedBox(height:10),
                                    Row(
                                      children: [
                                        Text("${water.toStringAsFixed(0)}", style: TextStyle(color: kGreenColor, fontWeight: FontWeight.bold, fontFamily: "Roboto", fontSize: 25),),
                                        SizedBox(width:5),
                                        Text("ml", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                      ],
                                    ),
                                  ],
                                ),
                                
                              ],
                            ),
                            SizedBox(height:15),
                            Divider(thickness: 2,),
                            SizedBox(height:10),
                            Text("Daily Dietary Intake", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18, fontFamily: "Roboto", color: Colors.black87),),
                            SizedBox(height:8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text("Calorie", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, fontFamily: "Roboto", color: kGreenColor),),
                                    SizedBox(height:2),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical:5, horizontal: 18),
                                      decoration: BoxDecoration(
                                        color: kWhiteColor,
                                        border:Border.all(color: kGreenColor, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: StreamBuilder(
                                        stream: Firestore.instance.collection("foods").snapshots(),
                                        builder: (ctx,snapShot){ 
                                          if (snapShot.hasData){
                                            final getDoc = snapShot.data.documents.where((doc) => doc.documentID == userinfo.userId).toList();
                                            if(getDoc.isNotEmpty){
                                              final checkToday = getDoc[0]["list"].where((doc) => doc["date"] == formattedDate).toList();
                                              double t = 0;
                                              checkToday.forEach((element){
                                                t += element["calorie"];
                                              });
                                              return Text((calorie - t).toStringAsFixed(0), style: TextStyle(fontSize: 20, color: kGreenColor, fontWeight: FontWeight.bold),);
                                            }
                                          }
                                          return Text(calorie.toStringAsFixed(0), style: TextStyle(fontSize: 20, color: kGreenColor, fontWeight: FontWeight.bold),);
                                        }
                                      ), 
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("Hydration", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, fontFamily: "Roboto", color: kGreenColor),),
                                    SizedBox(height:2),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical:5, horizontal: 18),
                                      decoration: BoxDecoration(
                                        color: kWhiteColor,
                                        border:Border.all(color: kGreenColor, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child:StreamBuilder(
                                        stream: Firestore.instance.collection("water").snapshots(),
                                        builder: (ctx,snapShot){ 
                                          if (snapShot.hasData){
                                            final getDoc = snapShot.data.documents.where((doc) => doc.documentID == userinfo.userId).toList();
                                            if(getDoc.isNotEmpty){
                                              final checkToday = getDoc[0]["list"].where((doc) => doc["date"] == formattedDate).toList();
                                              double t = 0;
                                              checkToday.forEach((element){
                                                t += element["height"];
                                              });
                                              return Text((water - t).toStringAsFixed(0), style: TextStyle(fontSize: 20, color: kGreenColor, fontWeight: FontWeight.bold),);
                                            }
                                          }
                                          return Text(water.toStringAsFixed(0), style: TextStyle(fontSize: 20, color: kGreenColor, fontWeight: FontWeight.bold),);
                                        }
                                      ),
                                      
                                    ),
                                  ],
                                )
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Calories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "RobotoSlab"),),
                                Text("Daily Intake", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: "RobotoSlab"),),
                              ],
                            ),

                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                                primary: kGreenColor,
                              ),
                              icon: Icon(Icons.add_outlined, color: kWhiteColor,), 
                              label: Text("Add Calorie", style: TextStyle(color: kWhiteColor),),
                              onPressed: (){
                                addFoodDialog(context);
                              }
                            )
                          ],
                        ),

                        SizedBox(height:10),

                        Container(
                          height:200,
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
                          child: Stack(
                            children: [
                              StreamBuilder(
                                stream: Firestore.instance.collection("foods").snapshots(),
                                builder: (ctx,snapShot){ 
                                  if (snapShot.hasData){
     
                                    final getDoc = snapShot.data.documents.where((doc) => doc.documentID == userinfo.userId).toList();
                                    if(getDoc.isNotEmpty){
                                      final checkToday = getDoc[0]["list"].where((doc) => doc["date"] == formattedDate).toList();

                                      return Container(
                                        padding: EdgeInsets.all(5),
                                        height:200,
                                        child: 
                                        checkToday.isEmpty ? Center(child: Image.asset("assets/img/empty.png"))      
                                        : ShowCalorieList(getDoc),

                                      );
                                    }
                                  }
                                  return Center(child: Image.asset("assets/img/empty.png"));
                                }
    
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hydration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "RobotoSlab"),),
                            Text("Daily Intake", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: "RobotoSlab"),),
                          ],
                        ),

                        SizedBox(height:10),

                        Container(
                          height:200,
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
                          child: StreamBuilder(
                            stream: Firestore.instance.collection("water").snapshots(),
                            builder: (ctx,snapShot){ 
                              if (snapShot.hasData){
                                final getDoc = snapShot.data.documents.where((doc) => doc.documentID == userinfo.userId).toList();
                                if(getDoc.isNotEmpty){
        
                                  final checkToday = getDoc[0]["list"].where((doc) => doc["date"] == formattedDate).toList();
                                  if(checkToday.isEmpty){total = 0;}else{
                                    total = checkToday[0]["height"];
                                  } 
                                }
                                if(total == null) total = 0;
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    WaveContainer(controller, total, water),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("${100 * total/water > 100 ? 100 : (100 * total/water).toStringAsFixed(0)}%", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kGreyColor),),
                                        Text("${total.toStringAsFixed(0)}ml", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kGreyColor),),
                                      ],
                                    ),
                                    Positioned(
                                      left:10,
                                      child: IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: (){manageWaterCalculation("remove", userWaterIntake.addWater, userinfo.userId);
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      right:10,
                                      child: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: (){manageWaterCalculation("add", userWaterIntake.addWater, userinfo.userId);},
                                      ),
                                    ),
                                  ]
                                );
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