import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/chg_psd_form.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  final Function () changeLoginState;
  LoginForm(this.changeLoginState);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email;
  String password;
  bool isWaiting = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      padding: EdgeInsets.only(left:20, right:20, top: 20),
      margin: EdgeInsets.symmetric(horizontal: 20),
      width:double.infinity,
      color: kWhiteColor.withOpacity(0.7),
      child: Form(
        key: _formKey,
        child:Column(
          children: [
            Text("Login", style: 
              TextStyle(
                fontFamily: "RobotoSlab",
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Email Address"),
              onChanged: (val){
                setState(() {
                  email = val;
                });
              },
              validator: (val){
                if(val.isEmpty){
                  return "Please fill in the blank";
                }
                return null;
              },
            ),

            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
              onChanged: (val){
                setState(() {
                  password = val;
                });
              },
              validator: (val){
                if(val.isEmpty){
                  return "Please fill in the blank";
                }
                return null;
              },
              obscureText: true,
            ),

            SizedBox(height: 10,),

            isWaiting ?         
            Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: double.infinity, height: 50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kGreenColor,
                    ),
                    child: Text("Confirm",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontFamily: "Roboto"
                      ),
                    ),
                    onPressed: (){
                      final isValid = _formKey.currentState.validate();
                      if(isValid)
                      _loginUser(email,password,context);
                    },
                  ),
                ),

                SizedBox(height: 10,),

                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: double.infinity, height: 50),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kGreyColor,
                      ),
                      child: Text("Cancel",
                        style: TextStyle(
                          color: kWhiteColor,
                          fontFamily: "Roboto"
                        ),
                      ),
                      onPressed: widget.changeLoginState,
                    ),
                ),
                  TextButton(child: Text("Forgot Password", style: TextStyle(color: Colors.black)), onPressed: (){
                    changePasswordDialog(context);
                  },
                ),
              ],
            ) : 
             Padding(
               padding: const EdgeInsets.only(bottom:8.0),
               child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.black54),),
             ),
            
          ],
        ),
      ),
    );
  }

  void _loginUser(String email, String password, BuildContext context) async{
    CurrentUser _currentUser = Provider.of<CurrentUser>(context,listen:false);
    try {
      setState(() {
        isWaiting = false;
      });
      bool result = await _currentUser.loginUser(email, password, context);
      if(result){
        setState(() {
          isWaiting = true;
        });
        Navigator.pushNamed(context, '/sharing');
      }else{
        setState(() {
          isWaiting = true;
        });
      }
    } catch(e){
      setState(() {
        isWaiting = true;
      });
      print(e);
    }
  }
}