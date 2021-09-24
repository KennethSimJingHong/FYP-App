import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class RadioButton extends StatefulWidget {
  final List list;
  final Function changeIndex;
  RadioButton(this.list,this.changeIndex);
  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height:30,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.list.length,
          itemBuilder: (ctx,i){
            return radioButton(widget.list[i],i);
          }
        ),
      ),
    );
  }

  void changeIndex(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  Widget radioButton(String txt, int index){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: ButtonTheme(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
                primary: selectedIndex == index? Colors.black: kWhiteColor,
              ),
            child: Text(txt, style: TextStyle(color: selectedIndex == index? kWhiteColor : Colors.black),),
            onPressed: (){
              widget.changeIndex(index);
              changeIndex(index);
            },
          ),
        ),
      );
    }
}