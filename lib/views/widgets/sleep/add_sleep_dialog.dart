
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/sleep.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_sleep.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class AddSleepDialog extends StatefulWidget {
  @override
  _AddSleepDialogState createState() => _AddSleepDialogState();
}

class _AddSleepDialogState extends State<AddSleepDialog> {
  final _formKey = GlobalKey<FormState>();
  String endTime = "00:00";
  var sleepDateTime = DateFormat("yyyy-MM-dd 00:00").format(DateTime.now());
  var wakeDateTime = DateFormat("yyyy-MM-dd 00:00").format(DateTime.now());
  int duration = 0;
  @override
  Widget build(BuildContext context) {
    UserSleep userSleep = Provider.of<UserSleep>(context);
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    return AlertDialog(
      title: Text("Record Your Sleep"),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Form(
            key:_formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/img/wake.png", scale: 0.8,),
                    DateTimePicker(
                      type: DateTimePickerType.time,
                      initialValue: "00:00",
                      timeLabelText: "Wake up at", 
                      onChanged: (val){
                        setState(() {
                          endTime = val;
                        });
                      },
                      validator: (val){
                        if(val.isEmpty){
                          return "Please fill in the blank";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height:20),
                    Column(
                      children: [
                        Text("Sleep for (Hour)"),
                        SizedBox(height:10),
                        NumberPicker(
                          selectedTextStyle: TextStyle(color: kGreenColor, fontSize: 20),
                          minValue: 0, 
                          maxValue: 100, 
                          value: duration, 
                          axis: Axis.horizontal,
                          onChanged: (val){
                            setState(() {
                              duration = val.toInt();
                            });
                          },
                          
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height:10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary:kGreenColor),
                      child: Text("Update Sleep DateTime"),
                      onPressed: (){
                        setState(() {
                          sleepDateTime = DateFormat("yyyy-MM-dd 00:00").format(DateTime.now());
                          wakeDateTime = DateFormat("yyyy-MM-dd " + endTime).format(DateTime.now());
                          sleepDateTime = DateTime.parse(wakeDateTime).subtract(Duration(hours: duration)).toString().replaceAll(":00.000","");
                        });
                      },
                    ),

                    SizedBox(height:30),
                    Image.asset("assets/img/sleep.png", scale: 0.8,),
                    SizedBox(height:10),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kGreenColor),
                      ),
                      child: Text(sleepDateTime, style: TextStyle(fontSize: 20, color: kGreenColor),)
                    ),
                  ],
                ),
                SizedBox(height:20),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        final isValid = _formKey.currentState.validate();
                        if(isValid){
                          Sleep newSleep = Sleep(sleepDateTime, wakeDateTime, userinfo.userId, duration);
                          userSleep.updateSleep(newSleep, context);
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
        ),
      ),
    );
  }
}

Future<Widget> addSleepDialog (BuildContext context)async{
  return await showDialog(
    context: context,
    builder: (BuildContext context) { return Center(child: SingleChildScrollView(child: AddSleepDialog())); },
  );
}