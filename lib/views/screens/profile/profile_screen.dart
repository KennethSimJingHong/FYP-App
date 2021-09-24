
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/fade_animation.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/radio_button.dart';
import 'package:healthy_lifestyle_app/views/widgets/profile/edit_info.dart';
import 'package:healthy_lifestyle_app/views/widgets/profile/fav_section.dart';
import 'package:healthy_lifestyle_app/views/widgets/profile/post_section.dart';
import 'package:healthy_lifestyle_app/views/widgets/profile/summary_section.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;
  bool checking = false;
  void changeIndex(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  Future _pickImage() async{
    final picker = ImagePicker();
    final pickImage = await picker.getImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 150,);
      if(pickImage != null){
        final pickedImageFile = File(pickImage.path);
        return pickedImageFile;
      }
  }
  

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context);
    User userinfo = currentUser.currentUserInfo;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: Padding(
          padding: const EdgeInsets.only(top:20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[ 
                FadeAnimation(1,"y",
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            checking == true ? CircularProgressIndicator()
                            :
                            GestureDetector(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children:[ 
                                  StreamBuilder(
                                    stream: Firestore.instance.collection("users").snapshots(),
                                    builder: (ctx, snapShot){
                                      if(snapShot.hasData){
                                        
                                        String url;
                                        snapShot.data.documents.forEach((element){
                                          if(element.data["user_id"] == userinfo.userId){
                                            url = element.data["image_url"];
                                          }
                                        });
                                        return CircleAvatar(
                                          backgroundImage: NetworkImage(url),
                                          radius: 30,
                                        );
                                      }
                                      return CircleAvatar(
                                        radius: 30,
                                      );
                                    }
                                  ),
                                  Positioned(
                                    right:-3.5,
                                    bottom:-3.5,
                                    child:
                                    ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(width:25,height:25),
                                      child: Container(
                                        child: Icon(Icons.image, size: 10, color: kWhiteColor,),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: kWhiteColor),
                                          borderRadius: BorderRadius.circular(20),
                                          color: kGreenColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                              ),
                              onTap: ()async{
                                File file = await _pickImage();
                                setState(() {
                                  checking = true;
                                });

                                bool result = await currentUser.updateImg(userinfo.imageUrl, file, userinfo.userId);
    
                                setState(() {
                                  checking = result;
                                });
                                
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:5, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userinfo.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Arial"),),
                                  Text(userinfo.email, style: TextStyle(fontSize: 14, fontFamily: "Roboto", color: Colors.black54),),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        Row(
                          children: [
                            // edit profile
                            IconButton(icon: Icon(Icons.edit_outlined), 
                              onPressed: (){
                                editProfileDialog(context, currentUser);
                              }
                            ),
                            // logout button
                            IconButton(icon: Icon(Icons.login_outlined), 
                              onPressed: (){
                                Navigator.of(context).pushReplacementNamed("/login");
                                FirebaseAuth.instance.signOut();
                              }
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                ),
                SizedBox(height:20),
                FadeAnimation(1.2,"y",
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical:10),
                        child: RadioButton(["My Post","Fav Post", "Summary"],changeIndex),
                      ),
                      selectedIndex == 0 ?
                      PostSection() : selectedIndex == 1 ?
                      FavSection() :
                      SummarySection(),
                    ],
                  ),
                ) 
              ]
            ),
          ),
        ),
        
      ),
    );
  }
}



