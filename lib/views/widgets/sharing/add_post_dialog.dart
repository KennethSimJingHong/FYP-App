import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/post.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_post.dart';
import 'package:healthy_lifestyle_app/views/widgets/sharing/post_image_picker.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/radio_button.dart';
import 'package:provider/provider.dart';
import 'package:healthy_lifestyle_app/models/user.dart' as Usr;

class PostDialogDisplay extends StatefulWidget {
  @override
  _PostDialogDisplayState createState() => _PostDialogDisplayState();
}

class _PostDialogDisplayState extends State<PostDialogDisplay> {
  final _formKey1 = new GlobalKey<FormState>();
  final _formKey2 = new GlobalKey<FormState>();
  final _formKey3 = new GlobalKey<FormState>();

  int selectedIndex = 0;

  void changeIndex(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  File _userImageFile;
  void _pickedImage(File image){
    _userImageFile = image;
  }

  String title;
  String category;
  String imageText = "No Image";
  List recipeContent = ["","",""];
  List exerciseContent = ["",""];
  List defaultContent = [""];

  void _addPost(Post post){
    UserPost postFunc = Provider.of<UserPost>(context,listen:false);
    try{
      postFunc.addPost(post);
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Post Something"),
      insetPadding: EdgeInsets.symmetric(horizontal:10, vertical: MediaQuery.of(context).size.width * .15),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width:MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical:10),
              child: RadioButton(["Recipe","Exercise","Others"],changeIndex)
            ),
            
            SizedBox(height:10),
            PostImagePicker(_pickedImage, imageText),
            
            selectedIndex == 0 ?
            recipeDialog() : selectedIndex == 1 ?
            exerciseDialog() : defaultDialog(),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text("Confirm", style: TextStyle(color: kWhiteColor),),
                    style: ElevatedButton.styleFrom(primary:kGreenColor),
                    onPressed: (){
                      bool isValid = false;
                      if(category == "Recipe"){
                        isValid = _formKey1.currentState.validate();
                      }else if(category == "Exercise"){
                        isValid = _formKey2.currentState.validate();
                      }else{
                        isValid = _formKey3.currentState.validate();
                      }
          
                      if(_userImageFile != null){
                        if(isValid){
                          Usr.User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
                          Post newpost = new Post("",title, category, userinfo.userId, _userImageFile, category == "Recipe" ? recipeContent : category == "Exercise" ? exerciseContent : defaultContent);
                          _addPost(newpost);
                          Navigator.of(context).pop();
                        }
                      }else{
                        setState(() {
                          imageText = "Please select a post image";
                        });
                      }
                      
                    },
                  ),
                ),
                SizedBox(width:10),
                Expanded(
                  child: ElevatedButton(
                    child: Text("Cancel", style: TextStyle(color: kWhiteColor),),
                    style: ElevatedButton.styleFrom(primary:kRedColor),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }

Widget recipeDialog(){
  setState(() {
    category = "Recipe";
    imageText = "No Image";
  });

  return Form(
    key: _formKey1,
    child: Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: "Recipe Name"),
          onChanged: (val){
            setState(() {
              title = val;
              
            });
          },
          validator: (val){
            if(val.isEmpty){
              return "Please fill in the blank";
            }
            return null;
          },
        ),
        SizedBox(height:10),
        TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            labelText: "Recipe Description", 
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black45,width:1)), 
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black45,width:1)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).errorColor,width:1)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).errorColor,width:2))
          ),
          onChanged: (val){
            setState(() {
              recipeContent[0] = val;
            });
          },
          validator: (val){
            if(val.isEmpty){
              return "Please fill in the blank";
            }
            return null;
          },
        ),
        SizedBox(height:10),
        TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            labelText: "Recipe Ingredient", 
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black45,width:1)), 
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black45,width:1)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).errorColor,width:1)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).errorColor,width:2))  
          ),
          onChanged: (val){
            setState(() {
              recipeContent[1] = val;
            });
          },
          validator: (val){
            if(val.isEmpty){
              return "Please fill in the blank";
            }
            return null;
          },
        ),
        SizedBox(height:10),
        TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            labelText: "Recipe Procedure", 
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black45,width:1)), 
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black45,width:1)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).errorColor,width:1)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).errorColor,width:2))
          ),
          onChanged: (val){
            setState(() {
              recipeContent[2] = val;
            });
          },
          validator: (val){
            if(val.isEmpty){
              return "Please fill in the blank";
            }
            return null;
          },
        ),
      ],
    ),
  );
}

Widget exerciseDialog(){
  setState(() {
    category = "Exercise";
    imageText = "No Image";
  });

  return Form(
    key: _formKey2,
    child: Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: "Exercise Plan"),
          onChanged: (val){
            setState(() {
              title = val;
            });
          },
          validator: (val){
            if(val.isEmpty){
              return "Please fill in the blank";
            }
            return null;
          },
        ),
        SizedBox(height:10),
        TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            labelText: "Exercise Plan Description", 
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black45,width:1)), 
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black45,width:1)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).errorColor,width:1)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).errorColor,width:2))
          ),
          onChanged: (val){
            setState(() {
              exerciseContent[0] = val;
            });
          },
          validator: (val){
            if(val.isEmpty){
              return "Please fill in the blank";
            }
            return null;
          },
        ),
        SizedBox(height:10),
        TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            labelText: "Exercise Plan Procedure", 
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black45,width:1)), 
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black45,width:1)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).errorColor,width:1)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).errorColor,width:2))  
          ),
          onChanged: (val){
            setState(() {
              exerciseContent[1] = val;
            });
          },
          validator: (val){
            if(val.isEmpty){
              return "Please fill in the blank";
            }
            return null;
          },
        ),
      ],
    ),
  );
}

Widget defaultDialog(){
  setState(() {
    category = "Default";
    imageText = "No Image";
  });
  
  return Form(
    key: _formKey3,
    child: Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: "Title"),
          onChanged: (val){
            setState(() {
              title = val;
            });
          },
          validator: (val){
            if(val.isEmpty){
              return "Please fill in the blank";
            }
            return null;
          },
        ),
        SizedBox(height:10),
        TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            labelText: "Description", 
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black45,width:1)), 
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black45,width:1)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).errorColor,width:1)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).errorColor,width:2))  
          ),
          onChanged: (val){
            setState(() {
              defaultContent[0] = val;
            });
          },
          validator: (val){
            if(val.isEmpty){
              return "Please fill in the blank";
            }
            return null;
          },
        ),
      ],
    ),
  );
}

}

Future<Widget> addPostDialog (BuildContext context)async{
  return await showDialog(
    context: context,
    builder: (_) => SingleChildScrollView(child: PostDialogDisplay()),
  );
}


