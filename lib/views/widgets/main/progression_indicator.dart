import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class ProgressionIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/img/logo.png",
            color: Colors.black,
          ),
          SizedBox(height:30),
          JumpingText("loading...", style: TextStyle(fontSize: 20),),
        ],
      ),
    );
  }
}