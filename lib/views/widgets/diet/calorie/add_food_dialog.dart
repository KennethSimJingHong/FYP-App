import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/calorie.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_food_intake.dart';
import 'package:healthy_lifestyle_app/views/widgets/diet/calorie/scan_food_detail.dart';
import 'package:healthy_lifestyle_app/views/widgets/diet/calorie/scanner.dart';
import 'package:intl/intl.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/LanguageHelper.dart';
import 'package:openfoodfacts/utils/ProductFields.dart';
import 'package:openfoodfacts/utils/ProductQueryConfigurations.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:healthy_lifestyle_app/models/user.dart' as Usr;

class FoodDialogDisplay extends StatefulWidget {
  @override
  _FoodDialogDisplayState createState() => _FoodDialogDisplayState();
}

class _FoodDialogDisplayState extends State<FoodDialogDisplay> {
  final _formKey = GlobalKey<FormState>();
  List nutriments = [];
  String result = "";
  double countTotalCal = 0.0;
  double carb;
  double fat;
  double protein;
  String title;
  bool isWaiting = false;
  
  Future scanQR() async{
    try{
      setState(() {
        isWaiting = true;
      });

      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", 
        "cancel", 
        false, 
        ScanMode.DEFAULT);
    
        result = barcodeScanRes;
        ProductQueryConfiguration configuration = ProductQueryConfiguration(
          result, language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]
        );
        ProductResult r = await OpenFoodAPIClient.getProduct(configuration);
        
        if(r.product != null){
          setState(() {
            isWaiting = false;
          });
          
          List<PieData> data = [
            PieData("Carbs", r.product.nutriments.carbohydrates, Color(0xFF2898FA)),
            PieData("Fat", r.product.nutriments.fat, Color(0xFF37CB49)),
            PieData("Proteins", r.product.nutriments.proteins, Color(0xFFFA4828)),
          ];
          Navigator.of(context).pop();
          showFoodDetailDialog(context, r.product, data);
        }else{
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Food not found."), backgroundColor: Theme.of(context).errorColor,));
        }

    }catch(e){
      setState(() {
        isWaiting = false;
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: e, backgroundColor: Theme.of(context).errorColor),);
      print(e);
    }
  }

  void _addFood(String id, Calorie cal) async{
    UserFoodIntake foodFunc = Provider.of<UserFoodIntake>(context, listen: false);
    try{
      foodFunc.addFood(id, cal);
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Usr.User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    
    return AlertDialog(
      title: Text("Record Your Food"),
      content: SingleChildScrollView(
        child: Form(
          key:_formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Scanner(scanQR, isWaiting),

              SizedBox(height:15),
              Text("Or", style: TextStyle(fontFamily: "Roboto"),),

              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                onChanged: (val){
                  setState(() {
                    title = val;
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
                decoration: InputDecoration(labelText: "Calorie"),
                keyboardType: TextInputType.number,
                onChanged: (val){
                  setState(() {
                    countTotalCal = double.parse(val);
                  });
                },
                validator: (val){
                  if(val.isEmpty){
                    return "Please fill in the blank";
                  }else if(num.tryParse(val) == null || val == 0.toString()){
                    return "Please enter the calorie";
                  }
                  return null;
                },
              ),
              SizedBox(height:30),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){
                      final isValid = _formKey.currentState.validate();
                      if(isValid){
                        var formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
                        Calorie newcal = new Calorie("",title, countTotalCal,formattedDate);
                        _addFood(userinfo.userId, newcal);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Confirm", style: TextStyle(color: kWhiteColor),),
                    style: ElevatedButton.styleFrom(primary:kGreenColor),
                  ),
                ),
                SizedBox(width:10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){Navigator.of(context).pop();},
                    child: Text("Cancel", style: TextStyle(color: kWhiteColor),),
                    style: ElevatedButton.styleFrom(primary:kRedColor),
                  ),
                ),
              ],
            )
            ],
          ),
        ),
      ),
    );
  }
}

Future<Widget> addFoodDialog (BuildContext context)async{
  return await showDialog(
    context: context,
    builder: (BuildContext context) { return Center(child: SingleChildScrollView(child: FoodDialogDisplay())); },
  );
}

class PieData{
  final String name;
  final double percent;
  final Color color;

  PieData(this.name, this.percent, this.color);
}