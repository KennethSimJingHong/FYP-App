import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/views/screens/diet/diet_screen.dart';
import 'package:healthy_lifestyle_app/views/screens/exercise/exercise_screen.dart';
import 'package:healthy_lifestyle_app/views/screens/profile/profile_screen.dart';
import 'package:healthy_lifestyle_app/views/screens/sharing/sharing_screen.dart';
import 'package:healthy_lifestyle_app/views/screens/sleep/sleep_screen.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  SnakeShape snakeShape = SnakeShape.circle;

  final _tabs = [
    SharingScreen(),
    DietScreen(),
    ExerciseScreen(),
    SleepScreen(),
    ProfileScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: snakeShape,
        snakeViewColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (i){
          setState(() {
            _selectedIndex = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Image.asset("assets/img/home.png", width: 35, color: _selectedIndex == 0 ? kWhiteColor : Colors.black), label: "Home"),
          BottomNavigationBarItem(icon: Image.asset("assets/img/dish.png", width: 35, color: _selectedIndex == 1 ? kWhiteColor : Colors.black), label: "Diet"),
          BottomNavigationBarItem(icon: Image.asset("assets/img/dumbell.png", width: 35, color: _selectedIndex == 2 ? kWhiteColor : Colors.black), label: "Exercise"),
          BottomNavigationBarItem(icon: Image.asset("assets/img/bed.png", width: 35, color: _selectedIndex == 3 ? kWhiteColor : Colors.black), label: "Sleep"),
          BottomNavigationBarItem(icon: Image.asset("assets/img/user.png", width: 35, color: _selectedIndex == 4 ? kWhiteColor : Colors.black), label: "Profile"),
        ],
      ),
    );
  }
}