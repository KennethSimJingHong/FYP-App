import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/progression_indicator.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/user_image_picker.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool isWaiting = false;


  List exerciseLvlList = ['Very Light (< 1 exercsise)', 'Light (1-2 exercises)', 'Moderate (3-4 exercises)', 'Heavy (5-6 exercises)', 'Very Heavy (> 6 exercises)'];
  
  String userEmail;
  String userName;
  String userPassword;
  int age;
  double height;
  double weight;
  double minutes;
  String whichGender = "male";
  String whichExeLvl;

  File _userImageFile;
  void _pickedImage(File image){
    _userImageFile = image;
  }

  int _currentStep = 0;
  List<Step> _steps(){
    List<Step> steps = [
      Step(
        title: Text("Create account"),
        content: Form(
          key: _formKey1,
          child: Column(
            children: [
              UserImagePicker(_pickedImage),
              TextFormField(
                decoration: InputDecoration(
                  labelText:"Username",
                ),
                validator: (val){
                  if(val.isEmpty){
                    return "Please fill in the blank";
                  }
                  else if (val.length < 4){
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

              FutureBuilder(
                future: Firestore.instance.collection("users").getDocuments(),
                builder: (ctx,snapShot){
                  if(snapShot.hasData){
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText:"Email Address",
                      ),
                      validator: (val){  
                        bool check = false;
                        
                        snapShot.data.documents.forEach((value){
                          if(value["email_address"] == val.trim()){
                            check = true;
                          }
                        });
                        if(val.isEmpty){
                          return "Please fill in the blank";
                        }
                        else if(!val.contains("@") || !val.contains(".")){
                          return "Please enter a valid email address.";
                        }
                        if(check){
                          return "Email address has been used";
                        }
                        return null;
                      },
                      onSaved: (val){
                        setState(() {
                          userEmail = val;
                        });
                      },
                      keyboardType: TextInputType.emailAddress,
                    );
                  }
                  return Container();
                }
              ),
              
              TextFormField(
                decoration: InputDecoration(
                  labelText:"Password",
                ),
                validator: (val){
                  if(val.isEmpty){
                    return "Please fill in the blank";
                  }
                  else if(val.length < 6){
                    return "Please enter at least 6 characters.";
                  }
                  return null;
                },
                onSaved: (val){
                  setState(() {
                    userPassword = val;
                  });
                },
                obscureText: true,
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text("Tell us more about you"),
        content: Form(
          key: _formKey2,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText:"Age",
                ),
                keyboardType: TextInputType.number,
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
              SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Male"),
                  Radio(value: "male", groupValue: whichGender, onChanged: (val){
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
              
              SizedBox(height:20),

              DropdownButtonFormField(
                hint:Text("Select Exercise Level"),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36,
                value: whichExeLvl,
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
        isActive: _currentStep >= 1,
      ),
    ];
    return steps;
  }

  @override
  Widget build(BuildContext context) {
    
    void _signUpUser(String username, String email, String password, String gender, int age, double weight, double height, double exerciseduration, String exerciselevel, File _userImageFile)async{
      CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
      isWaiting = true;

      try{
        if (await _currentUser.signUpUser(username, email, password, gender, age, weight, height, exerciseduration, exerciselevel, _userImageFile)){
          isWaiting = false;
          //login here
          bool result = await _currentUser.loginUser(email, password, context);
          if(result){
            isWaiting = false;
            Navigator.pushNamed(context, '/intro');
          }
        }
      }catch(e){
        print(e);
      }
    }

    return Scaffold(
      body: 
      isWaiting ?
      ProgressionIndicator() :
      Stepper(
        steps: _steps(),
        currentStep: this._currentStep,
        onStepTapped: (step){
          if(this._currentStep == 0){
            final isValid = _formKey1.currentState.validate();
            FocusScope.of(context).unfocus();
            if(isValid){
              setState(() {
                this._currentStep = step;
              });
            }
          }else{
            setState(() {
                this._currentStep = step;
              });
          }
        },
        controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: (){
                      if(this._currentStep == 0){
                        final isValid = _formKey1.currentState.validate();
                        FocusScope.of(context).unfocus();
                        if(_userImageFile != null){
                          if(isValid){
                            setState(() {
                              this._currentStep = this._currentStep + 1;
                            });
                          }
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a profile image."), backgroundColor: Theme.of(context).errorColor,));
                        }
                        
                      }else{
                        final isValid = _formKey2.currentState.validate();
                        FocusScope.of(context).unfocus();
                        if(isValid){
                          _formKey1.currentState.save();
                          _formKey2.currentState.save();
                          _signUpUser(userName,userEmail,userPassword,whichGender,age,weight,height,minutes,whichExeLvl,_userImageFile);
                        }
                      }
                    },
                    child: Text('Continue', style:TextStyle(color: kWhiteColor)),
                    style: ElevatedButton.styleFrom(primary: kGreenColor),
                  ),

                  SizedBox(width:20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: kRedColor),
                    onPressed: (){
                      setState(() {
                        if(this._currentStep > 0){
                          this._currentStep = this._currentStep - 1;
                        }else{
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    child: Text('Cancel'),
                  ),
                ],
            ),
          );
        },
      ),
    );
  }
}
