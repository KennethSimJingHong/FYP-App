import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/background.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/fade_animation.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/login_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = false;
  bool isWaiting = false;

  @override
  Widget build(BuildContext context) {

    void changeLoginState(){
      setState(() {
        isLogin = !isLogin;
      });
    }

    return Scaffold(
      body: Background(
        (isLogin == false) ?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,     
            children: [
              Column(
                children: [
                  FadeAnimation(1, "y", Image.asset("assets/img/logo.png")) ,
                  SizedBox(height:10),
                  FadeAnimation(1.2,"y",
                    Text("Leafie", style: 
                      TextStyle(
                        fontFamily: "RobotoSlab",
                        fontSize:30,
                        color: kWhiteColor,
                      ),
                    )
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: FadeAnimation(1.4,"y",
                  Column(
                    children: [

                      Text("Build a healthy lifestyle", style: 
                        TextStyle(
                          fontFamily: "RobotoSlab",
                          letterSpacing: 3,
                          fontSize:18,
                          color: kWhiteColor,
                        ),
                      ),

                      SizedBox(height: 50),

                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: double.infinity, height: 50),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: kGreenColor, 
                            ),
                            child: Text("Login",
                              style: TextStyle(
                                color: kWhiteColor,
                                fontFamily: "Roboto"
                              ),
                            ),
                            onPressed: (){
                              changeLoginState();
                            },
                          ),
                      ),
                      

                      SizedBox(height: 10,),

                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: double.infinity, height: 50),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary:kGreyColor),
                            child: Text("Create New Account",
                              style: TextStyle(
                                color: kWhiteColor,
                                fontFamily: "Roboto"
                              ),
                            ),
                            onPressed: (){
                              Navigator.of(context).pushNamed("/register");
                            },
                          ),
                      ),

                    ],
                  ),
                ),
              ) 
              
            ],
          ),
        ) :
        FadeAnimation(1,"y",
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginForm(changeLoginState),
            ],
          ),
        ),
      )
    );
  }
}
