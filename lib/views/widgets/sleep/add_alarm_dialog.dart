
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_sleep.dart';
import 'package:provider/provider.dart';

class AddAlarmDialog extends StatefulWidget {
  final UserSleep userSleep;
  AddAlarmDialog(this.userSleep);
  @override
  _AddAlarmDialogState createState() => _AddAlarmDialogState();
}

class _AddAlarmDialogState extends State<AddAlarmDialog> {
  String _valueChanged;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    return AlertDialog(
      title: Text("Add New Alarm"),
      insetPadding: EdgeInsets.symmetric(horizontal:10, vertical: MediaQuery.of(context).size.width * .15),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            DateTimePicker(
              timeHintText: "Pick a time",
              type: DateTimePickerType.time,
              onChanged: (val){
                setState(() {
                  _valueChanged = val;
                });
              },
              validator: (val){
                if(val.isEmpty){
                  return "Please pick a time";
                }
                return null;
              },
            ),
            SizedBox(height:20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text("Confirm", style: TextStyle(color: kWhiteColor),),
                    style: ElevatedButton.styleFrom(primary:kGreenColor),
                    onPressed: (){
                      final isValid = _formKey.currentState.validate();
                      if(isValid){
                        widget.userSleep.addAlarm(userinfo.userId, false, _valueChanged, context);
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
      )
    );
  }
}


Future<Widget> addAlarmDialog (BuildContext context, UserSleep userSleep)async{
  return await showDialog(
    context: context,
    builder: (_) => Center(child: SingleChildScrollView(child: AddAlarmDialog(userSleep))),
  );
}