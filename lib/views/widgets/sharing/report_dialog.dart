import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/report.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_post.dart';
import 'package:provider/provider.dart';

class ReportDialog extends StatefulWidget {
  final String postid;
  ReportDialog(this.postid);
  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  List reasonList = ["Nudity or pornography", "Irrelevant", "Hate content or symbols", "Violence", "Harassment or bullying", "Intellectual property violation", "Other"];
  String selectedReason;
  String comment;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserPost userPost = Provider.of<UserPost>(context);
    User userinfo = Provider.of<CurrentUser>(context).currentUserInfo;
    return AlertDialog(
      title: Text("Report The Post"),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
           child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField(
                hint:Text("Select your reason"),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 20,
                value: selectedReason,
                items: reasonList.map((value){
                  return DropdownMenuItem(child: Text(value), value: value);
                }).toList(), 
                onChanged: (value){
                  setState(() {
                    selectedReason = value;
                  }); 
                },
                validator: (val){
                  if(val == null){
                    return "Please pick a selection";
                  }
                  return null;
                },
              ),
              SizedBox(height:20),
              TextFormField(
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  labelText:"Justify your reason (optional)",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                onChanged: (val){
                  setState(() {
                    comment = val;
                  });
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text("Confirm", style: TextStyle(color: kWhiteColor),),
                      style: ElevatedButton.styleFrom(primary:kGreenColor),
                      onPressed: (){
                        final isValid = _formKey.currentState.validate();
                        if(isValid){
                          if(comment==null) comment = "no comment";
                          Report newReport = new Report("", widget.postid, userinfo.userId, comment, selectedReason);
                          userPost.reportPost(newReport);
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
        ),
      ),
    );
  }
}

Future<Widget> reportDialog (BuildContext context, String docid)async{
  return await showDialog(
    context: context,
    builder: (_) => Center(child: SingleChildScrollView(child: ReportDialog(docid))),
  );
}