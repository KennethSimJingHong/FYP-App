import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/views/widgets/sleep/alarm_widget.dart';

class ShowAlarmList extends StatefulWidget {
  final getDoc;
  final bool isManage, toChange;
  ShowAlarmList(this.getDoc,this.isManage,this.toChange);
  @override
  _ShowAlarmListState createState() => _ShowAlarmListState();
}

class _ShowAlarmListState extends State<ShowAlarmList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.getDoc.length ?? 0,
      itemBuilder: (ctx,i){

        return Container(
          key: Key(widget.getDoc[i]["time"]),
          padding:EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12))
          ),
          child: Row( 
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Padding(
                padding: const EdgeInsets.only(left:30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.getDoc[i]["time"], style: TextStyle(fontSize: 30, fontFamily: "Roboto"),),
                    Text("Alarm", style: TextStyle(color: Colors.black45),),
                  ],
                ),
              ),
              Container(width:100, height: 50, child: AlarmWidget(widget.isManage, widget.toChange, widget.getDoc[i], i)),
              
            ],
          ),
        );
      }
    ); 
  }
}



   