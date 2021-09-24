import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionaryScreen extends StatelessWidget {
  List<PageViewModel> getPages(){
    return[
      PageViewModel(
        image: Image.asset("assets/img/welcome.png"),
        title: "Welcome to Leafie",
        body: "Get started with Leafie that provides lots of amazing features",
      ),
      PageViewModel(
        image: Image.asset("assets/img/lifestyle.png"),
        title: "Lifestyle Managing",
        body: "Plan for healthy living and keep track of your daily habits",
      ),
      PageViewModel(
        image: Image.asset("assets/img/connected.png"),
        title: "Staying Connected",
        body: "Make friends daily and start conversation with them",
      ),
      PageViewModel(
        image: Image.asset("assets/img/sharing.png"),
        title: "Knowledge Sharing",
        body: "Exchange knowledge and share posts to every users",
      ),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: kWhiteColor,
      done: Text("Let's go"),
      onDone: (){
        Navigator.pushNamed(context, '/sharing');
      },
      pages: getPages(),
    );
  }
}