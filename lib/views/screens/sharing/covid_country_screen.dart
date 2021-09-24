import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/progression_indicator.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/views/widgets/covid/search_covid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CovidCountryScreen extends StatefulWidget {
  @override
  _CovidCountryScreenState createState() => _CovidCountryScreenState();
}

class _CovidCountryScreenState extends State<CovidCountryScreen> {
  List _worldCovidData;

  void getCovidData() async {
    http.Response response =
        await http.get('https://disease.sh/v3/covid-19/countries');
        
    setState(() {
      _worldCovidData = json.decode(response.body);
    });
  }

   @override
  void initState() {
    getCovidData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _worldCovidData == null ? ProgressionIndicator() :

      SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back), 
                  color: kGreenColor,
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
                ),
                
                Text("Country Covid Case", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

                IconButton(icon: Icon(Icons.search), onPressed: (){
                  showSearch(context: context, delegate: Search(_worldCovidData));
                }),
                
              ],
            ),
            

            Container(
              color: Colors.yellow[200],
              width:double.infinity,
              height:50,
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Please take note that some countries have not announce their today result.", style: TextStyle(fontWeight: FontWeight.bold),),
              )
            ),

            Expanded(
              child: Container(
                height:MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemBuilder: (context,i){
                    return Container(
                      height:210,
                      margin:EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:kWhiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius:10,
                            offset: Offset(0,5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Container(
                              child:Column(   
                                children: [
                                  Text(_worldCovidData[i]["country"], style:TextStyle(fontWeight: FontWeight.bold, fontSize:20)),
                                  Image.network(_worldCovidData[i]["countryInfo"]["flag"], height:100, width:110)
                                ],
                              )
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("CONFIRMED   ", style: TextStyle(color: kOrangeColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                            Text("ACTIVE   ", style: TextStyle(color: kGreenColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                            Text("RECOVERED   ", style: TextStyle(color: kPurpleColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                            Text("DEATHS  ", style: TextStyle(color: kRedColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(_worldCovidData[i]["cases"].toString(), style:TextStyle(color: kOrangeColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                            Text(_worldCovidData[i]["active"].toString(), style:TextStyle(color: kGreenColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                              Text(_worldCovidData[i]["recovered"].toString(), style:TextStyle(color: kPurpleColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                            Text(_worldCovidData[i]["deaths"].toString(), style:TextStyle(color: kRedColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                          ],
                                        )
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("TODAY'S CASES   ", style: TextStyle(color: kOrangeColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                            Text("TODAY'S RECOVERED  ", style: TextStyle(color: kPurpleColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                            Text("TODAY'S DEATHS   ", style: TextStyle(color: kRedColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                            
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(_worldCovidData[i]["todayCases"].toString(), style:TextStyle(color: kOrangeColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                            Text(_worldCovidData[i]["todayRecovered"].toString(), style:TextStyle(color: kPurpleColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                            Text(_worldCovidData[i]["todayDeaths"].toString(), style:TextStyle(color: kRedColor, fontWeight: FontWeight.bold, fontSize: 13),), 
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
            ),    
          ],
        ),
      ),
          
    );
  }
}