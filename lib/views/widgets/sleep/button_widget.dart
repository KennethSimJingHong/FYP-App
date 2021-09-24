import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class ButtonHeaderWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonHeaderWidget({
    Key key,
    @required this.text,
    @required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => OutlinedButton(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
      backgroundColor: kGreenColor,
      side: BorderSide(width: 2.0, color: kGreenColor),
    ),
    child: Text(text, style: TextStyle(color: kGreenColor),),
    onPressed: onClicked,
  );
}

