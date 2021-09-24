import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/exercise.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_exerise_program.dart';
import 'package:provider/provider.dart';

class AddExerciseDialog extends StatefulWidget {
  @override
  _AddExerciseDialogState createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<AddExerciseDialog> {
  String title, desc, _duration = "";
  Duration resultDuration;
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    final exerciseprogram = Provider.of<UserExerciseProgram>(context);
    return AlertDialog(
      title: Text("Add new exercise"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              }
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Short Description"),
              onChanged: (val){
                setState(() {
                  desc = val;
                });
              },
              validator: (val){
                if(val.isEmpty){
                  return "Please fill in the blank";
                }
                return null;
              }
            ),
            SizedBox(height:10),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: double.infinity, height: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kGreenColor
                ),
                child: _duration == "" ? Text("Duration") : Text(_duration),
                onPressed: ()async{
                  resultDuration = await showDurationPicker(
                    context: context, 
                    initialTime: Duration(minutes: 0),
                  );
                  if(resultDuration != null){
                    if(resultDuration.toString().split(":")[0] != "0"){
                      if(resultDuration.toString().split(":")[1] != "00"){
                        setState(() {
                          _duration = resultDuration.toString().split(":")[0] + "hr " + resultDuration.toString().split(":")[1] + "min ";
                        });
                      }else{
                        setState(() {
                          _duration = resultDuration.toString().split(":")[0] + "hr ";
                        });
                      }
                    }else{
                      if(resultDuration.toString().split(":")[1] != "00"){
                        setState(() {
                          _duration = resultDuration.toString().split(":")[1] + "min ";
                        });
                      }else{
                        setState(() {
                          _duration = resultDuration.toString().split(":")[1] + "min ";
                        });
                      }
                    }
                  }
                  
                },
              ),
            ),
            SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){
                      final isValid = _formKey.currentState.validate();
                      if(isValid){
                        
                       exerciseprogram.addExercise(userinfo.userId, new Exercise("", title, desc, _duration == "" ? "0min" : _duration, false));
                       Navigator.of(context).pop();
                      }
                    },
                    child: Text("Confirm", style: TextStyle(color: kWhiteColor),),
                    style: ElevatedButton.styleFrom(primary:kGreenColor),
                  ),
                ),
                SizedBox(width:10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){Navigator.of(context).pop();},
                    child: Text("Cancel", style: TextStyle(color: kWhiteColor),),
                    style: ElevatedButton.styleFrom(primary:kRedColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<Widget> addExerciseDialog(BuildContext context)async{
  return await showDialog(
    context: context,
    builder:(_) => Center(child: SingleChildScrollView(child: AddExerciseDialog())),
  );
}

