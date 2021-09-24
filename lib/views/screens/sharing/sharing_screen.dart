import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/views/widgets/sharing/add_post_dialog.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/fade_animation.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/radio_button.dart';
import 'package:healthy_lifestyle_app/views/widgets/sharing/show_post_list.dart';

class SharingScreen extends StatefulWidget {
  @override
  _SharingScreenState createState() => _SharingScreenState();
}

class _SharingScreenState extends State<SharingScreen> {
  
  int selectedIndex = 0;

  void changeIndex(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            FadeAnimation(1,"y",
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Text("Leafie", style: TextStyle(fontFamily: "RobotoSlab", fontSize: 25, fontWeight: FontWeight.bold),),
                  ),

                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
                          elevation: 0,
                          primary: Colors.black.withOpacity(0),
                          shadowColor: Colors.black.withOpacity(0),
                        ),
                        child:Column(
                          children: [
                            Image.asset("assets/img/covid.png", width: 25, height: 25,),
                            SizedBox(width:5),
                            Text("Covid Case", style: TextStyle(fontSize: 12, color: Colors.black)),
                          ],
                        ),
                        onPressed: (){
                          Navigator.of(context).pushNamed(
                          "/covid"
                          );
                        }
                      ),
                      
                      IconButton(icon: Icon(Icons.chat_outlined), onPressed: (){
                        Navigator.of(context).pushNamed("/msg");
                      }),
                      IconButton(
                        icon: Icon(Icons.add), 
                        onPressed: (){
                          addPostDialog(context);
                        },
                      ),
                      
                    ],
                  ),
                ], 
              ),
            ),
            Expanded(
              child: FadeAnimation(1.2, "y", 
                Column(
                  children: [
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(vertical:10),
                      child: RadioButton(["Recipe","Exercise","Others"],changeIndex),
                    ),
                    ShowPostList(selectedIndex),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), 
    );
  }
}