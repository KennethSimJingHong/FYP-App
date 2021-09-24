import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class PostInfoScreen extends StatefulWidget {
  @override
  _PostInfoScreenState createState() => _PostInfoScreenState();
}

class _PostInfoScreenState extends State<PostInfoScreen> {

  Widget contentBox(String title,String data){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
          SizedBox(height:6),
          Text(data, style: TextStyle(fontSize: 15),),
        ],
      ),
    );
  } 

  @override
  Widget build(BuildContext context) {
    final List getDoc = ModalRoute.of(context).settings.arguments;

    DateTime currentdatetime = new DateTime.now();
    DateTime postTime = DateTime.fromMicrosecondsSinceEpoch(getDoc[0]["createdAt"].microsecondsSinceEpoch);
    final durationInMinutes = currentdatetime.difference(postTime).inMinutes;
    final durationInHours = currentdatetime.difference(postTime).inHours;
    final durationInDays = currentdatetime.difference(postTime).inDays;

    return Scaffold(
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: "${getDoc[0]["image_url"]}",
                  child: Image.network(
                    getDoc[0]["image_url"],
                    width: double.infinity,
                    height:280,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left:5,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonTheme(
                        minWidth: 20,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: kWhiteColor.withOpacity(.8),
                          ),
                          onPressed: (){ 
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.navigate_before, color: Colors.black,),
                        ),
                      ),
                    ],
                  ),
                ),          
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:15.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(backgroundImage: NetworkImage(getDoc[1]["image_url"]),),
                          SizedBox(width:8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 200,
                                child: Text(getDoc[0]["title"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Roboto"),)
                              ),
                              SizedBox(height:5),
                              Container(
                                width: MediaQuery.of(context).size.width - 200,
                                child: Text("by ${getDoc[1]["username"]}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),)),
                            ],
                          ),
                        ],
                      ), 
                      
                      Container(decoration: BoxDecoration(border:Border.all(color: Colors.black38), borderRadius: BorderRadius.circular(10)), padding: EdgeInsets.all(8), child: Text(durationInDays >= 1 ? 
                                      (durationInDays == 1 ? "$durationInDays day ago" : "$durationInDays days ago")
                                      : durationInHours >= 1 ? (durationInHours == 1 ? "$durationInHours hour ago" :"$durationInHours hours ago") 
                                      : durationInMinutes >= 1 ? (durationInMinutes == 1 ? "$durationInMinutes minute ago" : "$durationInMinutes minutes ago") 
                                      : "Few seconds ago", style: TextStyle(color: Colors.black87, fontSize: 11),),),
                    ],
                  ),
                ),

                SizedBox(height:10),
                contentBox("Description",getDoc[0]["content"][0]),
                SizedBox(height:10),
                getDoc[0]["category"] == "Exercise" || getDoc[0]["category"] == "Recipe" ?
                contentBox(getDoc[0]["category"] == "Exercise" ? "Procedure" : "Ingredient",getDoc[0]["content"][1]) : Container(),
                SizedBox(height:10),
                getDoc[0]["category"] == "Recipe" ?
                contentBox("Procedure",getDoc[0]["content"][2]) : Container(),
              ],
            ),
            
          ],
        ),
      )
    );
  }
}