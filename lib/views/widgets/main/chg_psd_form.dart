
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class ChgPsdForm extends StatefulWidget {
  @override
  _ChgPsdFormState createState() => _ChgPsdFormState();
}

class _ChgPsdFormState extends State<ChgPsdForm> {
  String email;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text("Edit Password"),
      content: FutureBuilder(
          future: Firestore.instance.collection("users").getDocuments(),
          builder: (ctx,snapShot){
            if(snapShot.hasData){
              return Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: "Email Address"),
                      onChanged: (val){
                        setState(() {
                          email = val;
                        });
                      },
                      validator: (val){
                        bool check = false;
                        
                        snapShot.data.documents.forEach((value){
                          if(value["email_address"] == val.trim()){
                            check = true;
                          }
                        });

                        if(!check){
                          return "Email address cannot be found";
                        }

                        if(val.isEmpty){
                          return "Please fill in the blank";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height:10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text("Confirm", style: TextStyle(color: kWhiteColor),),
                              style: ElevatedButton.styleFrom(primary:kGreenColor),
                              onPressed: (){
                                final isValid = _formKey.currentState.validate();
                                if(isValid){
                                  try{
                                    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("A reset form has sent to your email.", style: TextStyle(color: kWhiteColor),), backgroundColor: kGreenColor,));
                                  }on PlatformException catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(), style: TextStyle(color: kWhiteColor),), backgroundColor: Theme.of(context).errorColor,));
                                  }
                                  catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(), style: TextStyle(color: kWhiteColor),), backgroundColor: Theme.of(context).errorColor,));
                                  }
                                  
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
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        )
    );
  }
}

Future changePasswordDialog(BuildContext context)async{
  return await showDialog(
    context: context, 
    builder: (_) => Center(child: SingleChildScrollView(child: ChgPsdForm())),
  );
}