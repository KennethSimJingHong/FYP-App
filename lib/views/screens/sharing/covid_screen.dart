import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/views/widgets/covid/covid_data_cont.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/fade_animation.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/progression_indicator.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:url_launcher/url_launcher.dart';

class CovidScreen extends StatefulWidget {
  @override
  _CovidScreenState createState() => _CovidScreenState();
}

class _CovidScreenState extends State<CovidScreen> {

  Widget symptomsWidget(String img, String title){
    return Container(
      width:90,
      height:100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kWhiteColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(1.0,2.0),
            color:Colors.black26,
          ),
        ]
      ),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(img, scale: 0.75,),
          Text(title, style: TextStyle(fontFamily: "RobotoSlab", fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget preventionsWidget(String img, String title, String description){
    return Container(
      margin: EdgeInsets.symmetric(horizontal:20, vertical:5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kWhiteColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(1.0,2.0),
            color:Colors.black26,
          ),
        ]
      ),
      child: Row(
        children: [
          Image.asset(img),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "RobotoSlab", fontSize: 16),),
                SizedBox(height:5),
                Text(description, style: TextStyle(color: Colors.black87, fontFamily: "Roboto", fontSize: 13),)
              ],
            ),
          )
        ],
      ),
    );
  }

  Timer timer;
  var formattedDate = DateFormat("d MMMM y").add_jms().format(DateTime.now().toUtc());
  void _getCurrentTime()  {
    final utcNow = DateFormat("d MMMM y").add_jms().format(DateTime.now().toUtc());
    setState(() {
      formattedDate = utcNow;
    });
  }

  Map _worldCovidData;

  void getWorldData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      _worldCovidData = json.decode(response.body);
    });
  }
  
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => _getCurrentTime());
    getWorldData();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  openURL() async{
    if(await canLaunch("http://www.emro.who.int/health-topics/corona-virus/myth-busters.html")){
      await launch("http://www.emro.who.int/health-topics/corona-virus/myth-busters.html");
    }else{
      throw "Could not launch URL";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
    body: 
      _worldCovidData == null ? ProgressionIndicator() :
      Container(
        color: kWhiteColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 550,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF565E7B), Color(0xFF152A71)],
                      ),
     
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset:Offset(0.0, 4.0),
                          blurRadius: 6.0,
                        ),
                      ]
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 40, left:5),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back), 
                      color: kWhiteColor,
                      onPressed: (){
                        Navigator.of(context).pop();
                      }
                    ),
                  ),

                  Positioned(
                    left: 50,
                    top: 60,
                    child: FadeAnimation(1,"y", Image.asset("assets/img/covid_virus.png"))
                  ),

                  Positioned(
                    left: MediaQuery.of(context).size.width/2,
                    top: 35,
                    child: FadeAnimation(1.2, "y",Image.asset("assets/img/covid_virus.png",
                    scale: 1.3,
                      )    
                    )
                  ),

                  Positioned(
                    right: 25,
                    top: 50,
                    child: FadeAnimation(1.4, "y",Image.asset("assets/img/covid_virus.png",
                    scale: 1.1,
                      )
                    )
                  ),
  
                  FadeAnimation(1.6,"y",
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height:120),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Worldwide",
                                style: TextStyle(
                                  color: kWhiteColor,
                                  fontFamily: "RobotoSlab",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              
                              ButtonTheme(
                                height: 30,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: kGreenColor,
                                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20),),
                                  ),
                                  child: Text("Country", style: TextStyle(color: kWhiteColor),),
                                  onPressed: (){
                                    Navigator.of(context).pushNamed(
                                    "/country"
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:20),
                          child: Text(
                            "$formattedDate",
                            style: TextStyle(
                              color: kWhiteColor,
                              fontFamily: "RobotoSlab",
                              fontWeight: FontWeight.w100,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CovidDataCont(Color(0xFF92C02B), "Active", _worldCovidData["active"]),
                            CovidDataCont(Color(0xFFFF414D), "Deaths", _worldCovidData["deaths"]),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CovidDataCont(Color(0xFF515CF5), "Recovered", _worldCovidData["recovered"]),
                            CovidDataCont(Color(0xFFFFA73E), "Confirmed", _worldCovidData["cases"]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height:20),

              FadeAnimation(1.8,"y",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Symptoms",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "RobotoSlab",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        symptomsWidget("assets/img/image 12.png", "Cough"),
                        symptomsWidget("assets/img/image 13.png", "Fever"),
                        symptomsWidget("assets/img/image 14.png", "Tiredness"),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height:20),

              FadeAnimation(1.8,"y",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Preventions",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "RobotoSlab",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        preventionsWidget("assets/img/pablo-keep-your-hands-clean 1.png", "Clean your hands", "Clean your hands often. Use soap and water or an alcohol-based hand rub."),
                        preventionsWidget("assets/img/cherry-wear-mask 1.png", "Wear a mask", "Wear a mask when physical distancing is not possible. Don’t touch your eyes, nose or mouth."),
                        preventionsWidget("assets/img/clip-keep-distance-sign-keep-the-15-meter-distance-1 1.png", "Keep in a distance", "Always keep a distance of 1.5 meter from person in front. Maintain a safe distance from anyone who is coughing or sneezing."),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ButtonTheme(
                  minWidth: double.infinity,
                  child: ElevatedButton(
                    child: Text("Get to know more", 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: kWhiteColor,
                      elevation: 0,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: openURL,
                  ),
                ),
              ),

              SizedBox(height:20),
            ],
          ),
        ),
      ),
      
    );
  }
}