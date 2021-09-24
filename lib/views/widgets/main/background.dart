import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  Background(this.child);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height:size.height,
          width: double.infinity,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/img/forest_background.jpeg",),
                    colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.95),BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}