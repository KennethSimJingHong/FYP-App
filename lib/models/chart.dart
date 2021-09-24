import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class Chart{
  int id;
  String name;
  Color color = kWhiteColor;
  double y;

  Chart(this.id,this.name, {this.y = 0});
}