import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';

class EditInfo extends StatefulWidget {
  final CurrentUser currentUser;
  EditInfo(this.currentUser);
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  final _formKey = GlobalKey<FormState>();
  bool isWaiting = false;


  List exerciseLvlList = ['Very Light (< 1 exercsise)', 'Light (1-2 exercises)', 'Moderate (3-4 exercises)', 'Heavy (5-6 exercises)', 'Very Heavy (> 6 exercises)'];
  String userName;
  int age;
  double height;
  double weight;
  double minutes;
  String whichGender;
  String whichExeLvl;

  @override
  void initState() {
    User userinfo = widget.currentUser.currentUserInfo;
    whichGender = userinfo.gender;
    super.initState();
  }

  @override
  
  Widget build(BuildContext context) {
    User userinfo = widget.currentUser.currentUserInfo;
    return AlertDialog(
      insetPadding: EdgeInsets.all(8.0),
      title: Text("Edit User Information"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: userinfo.username,
                  decoration: InputDecoration(
                    labelText: "Username",
                  ),
                  validator: (val){
                    if(val.isEmpty){
                      return "Please fill in the blank";
                    }
                    else if(val.length < 4){
                      return "Please enter at least 4 characters.";
                    }
                    return null;
                  },
                  onSaved: (val){
                    setState(() {
                      userName = val;
                    });
                  },
                ),

                TextFormField(
                  initialValue: userinfo.age.toString(),
                  decoration: InputDecoration(
                    labelText:"Age",
                  ),
                  validator: (val){
                    if(val.isEmpty){
                      return "Please fill in the blank";
                    }else if(num.tryParse(val) == null || val == 0.toString()){
                      return "Please enter your age";
                    }
                    return null;
                  },
                  onSaved: (val){
                    setState(() {
                      age = int.parse(val);
                    });
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Male"),
                    Radio(value: "male", groupValue: whichGender , onChanged: (val){
                      setState(() {
                        whichGender = val;
                      });
                    }),
                    SizedBox(width:50),
                    Text("Female"),
                    Radio(value: "female", groupValue: whichGender, onChanged: (val){
                      setState(() {
                        whichGender = val;
                      });
                    }),
                  ],
                ),
                
                TextFormField(
                  initialValue: userinfo.weight.toString(),
                  decoration: InputDecoration(
                    labelText:"Weight in kg",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val){
                    if(val.isEmpty){
                      return "Please fill in the blank";
                    }
                    else if(num.tryParse(val) == null || val == 0.toString()){
                      return "Please enter your weight";
                    }
                    return null;
                  },
                  onSaved: (val){
                    setState(() {
                      weight = double.parse(val);
                    });
                  },
                ),

                TextFormField(
                  initialValue: userinfo.height.toString(),
                  decoration: InputDecoration(
                    labelText:"Height in cm",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val){
                    if(val.isEmpty){
                      return "Please fill in the blank";
                    }
                    else if(num.tryParse(val) == null || val == 0.toString()){
                      return "Please enter your height";
                    }
                    return null;
                  },
                  onSaved: (val){
                    setState(() {
                      height = double.parse(val);
                    });
                  },
                ),

                TextFormField(
                  initialValue: userinfo.exerciseDuration.toString(),
                  decoration: InputDecoration(
                    labelText:"Exercise per time (minute)",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val){
                    if(val.isEmpty){
                      return "Please fill in the blank";
                    }
                    else if(num.tryParse(val) == null || val == 0.toString()){
                      return "Please enter your exercise durationse";
                    }
                    return null;
                  },
                  onSaved: (val){
                    setState(() {
                      minutes = double.parse(val);
                    });
                  },
                ),

                DropdownButtonFormField(
                  hint:Text("Select Exercise Level"),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 36,
                  value: userinfo.exerciseLevel,
                  items: exerciseLvlList.map((value){
                    return DropdownMenuItem(child: Text(value), value: value);
                  }).toList(), 
                  onChanged: (value){
                    setState(() {
                      whichExeLvl = value;
                    }); 
                  },
                  isExpanded: true,
                  validator: (val){
                    if(val == null){
                      return "Please pick a selection";
                    }
                    return null;
                  },
                ),

              ],
            ),
          ),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text("Confirm", style: TextStyle(color: kWhiteColor),),
                  style: ElevatedButton.styleFrom(primary:kGreenColor),
                  onPressed: (){
                    final isValid = _formKey.currentState.validate();
                    FocusScope.of(context).unfocus();
                    if(isValid){
                      _formKey.currentState.save();
                      widget.currentUser.updateUserData(userName, age, height, weight, minutes, whichGender, whichExeLvl ?? userinfo.exerciseLevel, userinfo.userId);
                      Navigator.of(context).pop();
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
}

Future<Widget> editProfileDialog(BuildContext context, CurrentUser currentUser) async{
  return await showDialog(
    context: context,
    builder: (BuildContext context)  => Center(child: SingleChildScrollView(child: EditInfo(currentUser))),
  );
}