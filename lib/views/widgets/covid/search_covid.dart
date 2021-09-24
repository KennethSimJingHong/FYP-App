import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class Search extends SearchDelegate{
  final List countryList;
  Search(this.countryList);
  @override
  List<Widget> buildActions(BuildContext context) {
      return[
        IconButton(icon:Icon(Icons.clear), onPressed:(){
          query="";
        })
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(icon:Icon(Icons.arrow_back), onPressed: (){
        Navigator.pop(context);
      });
    }
  
    @override
    Widget buildResults(BuildContext context) {
      return Container();
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
      final suggestionList = query.isEmpty?countryList : countryList.where((element) => element['country'].toString().toLowerCase().startsWith(query)).toList();
      return ListView.builder(itemCount:suggestionList.length, itemBuilder: (context,i){
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
                      Text(suggestionList[i]["country"], style:TextStyle(fontWeight: FontWeight.bold, fontSize:20)),
                      Image.network(suggestionList[i]["countryInfo"]["flag"], height:100, width:110)
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
                                Text(suggestionList[i]["cases"].toString(), style:TextStyle(color: kOrangeColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                Text(suggestionList[i]["active"].toString(), style:TextStyle(color: kGreenColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                  Text(suggestionList[i]["recovered"].toString(), style:TextStyle(color: kPurpleColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                Text(suggestionList[i]["deaths"].toString(), style:TextStyle(color: kRedColor, fontWeight: FontWeight.bold, fontSize: 13),),
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
                                Text(suggestionList[i]["todayCases"].toString(), style:TextStyle(color: kOrangeColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                Text(suggestionList[i]["todayRecovered"].toString(), style:TextStyle(color: kPurpleColor, fontWeight: FontWeight.bold, fontSize: 13),),
                                Text(suggestionList[i]["todayDeaths"].toString(), style:TextStyle(color: kRedColor, fontWeight: FontWeight.bold, fontSize: 13),), 
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
      });
  }

}