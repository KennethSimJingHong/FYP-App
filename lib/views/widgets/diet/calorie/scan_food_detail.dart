import 'package:date_time_picker/date_time_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/calorie.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_food_intake.dart';
import 'package:healthy_lifestyle_app/views/widgets/diet/calorie/add_food_dialog.dart';
import 'package:healthy_lifestyle_app/views/widgets/diet/calorie/indicator_widget.dart';
import 'package:openfoodfacts/model/NutrientLevels.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:provider/provider.dart';


class ScanFoodDetail extends StatefulWidget {
  final Product product;
  final List<PieData> data;
  ScanFoodDetail(this.product, this.data);

  @override
  _ScanFoodDetailState createState() => _ScanFoodDetailState();
}

class _ScanFoodDetailState extends State<ScanFoodDetail> {
  final _formKey = GlobalKey<FormState>();
  int grams;

    void _addFood(String id, Calorie cal) async{
    UserFoodIntake foodFunc = Provider.of<UserFoodIntake>(context, listen: false);
    try{
      foodFunc.addFood(id, cal);
    }catch(e){
      print(e);
    }
  }
  

  Widget nutriLevel(Level level, String nutrient){
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8),
          width:45,
          height:45, 
          decoration: BoxDecoration(
            color: level == Level.HIGH ? Colors.red : level == Level.MODERATE ? Color(0xFFDFEA02) : Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(level == Level.HIGH ? "H" : level == Level.MODERATE ? "M" : "L", style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold, fontFamily: "RobotoSlab"))
        ),
        SizedBox(height:5),
        Text(nutrient, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(widget.product.productName, style: TextStyle(fontSize: 25, fontFamily: "Roboto", fontWeight: FontWeight.bold),),
        SizedBox(height:5),
        Text("for ${widget.product.nutrimentDataPer}", style: TextStyle(fontSize: 20, fontFamily: "Roboto"),)
      ],),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height:20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Calorie:  ", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),), 
              Text("${widget.product.nutriments.energyKcal.toStringAsFixed(0)} kcal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontFamily: "Roboto"),),
            ],
          ),

          SizedBox(height:30),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Nutri-Score:  ", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                width:45,
                height:45, 
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: widget.product.nutriscore == "A" ? Color(0xFF188738) : widget.product.nutriscore == "B" ? Color(0xFF24C653) : widget.product.nutriscore == "C" ? Color(0xFFDFEA02) : widget.product.nutriscore == "D" ? Color(0xFFFBB424) : Color(0xFFFB5924),
                ),
                child: Text(widget.product.nutriscore.toUpperCase(), style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold, fontFamily: "RobotoSlab"),),
              )
            ],
          ),
          
          SizedBox(height:20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 200,
                height:200,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: widget.data
                    .asMap()
                    .map<int, PieChartSectionData>(
                      (index, data) {
                        final value = PieChartSectionData(
                          color: data.color,
                          value: data.percent,
                          title: "${data.percent}g",
                          titleStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kWhiteColor,
                          )
                        );
                        return MapEntry(index, value);
                      }
                    ).values.toList() 
                  )
                ),
              ),

              IndicatorsWidget(widget.data),
            ],
          ),

          SizedBox(height:20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              nutriLevel(widget.product.nutrientLevels.levels.values.elementAt(0), "Sugar"),
              nutriLevel(widget.product.nutrientLevels.levels.values.elementAt(1), "Fat"),
              nutriLevel(widget.product.nutrientLevels.levels.values.elementAt(2), "Saturated Fat"),
              nutriLevel(widget.product.nutrientLevels.levels.values.elementAt(3), "Salt"),
            ],
          ),

          SizedBox(height:20),

          Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "How many grams have you taken?",
              ),
              validator: (val){
                if(val.isEmpty || val == 0.toString()){
                  return "Please enter a number";
                }
                return null;
              },
              onSaved: (val){
                setState(() {
                  grams = int.parse(val);
                });
              },
            ),
          ),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text("Confirm", style: TextStyle(color: kWhiteColor),),
                  style: ElevatedButton.styleFrom(primary:kGreenColor),
                  onPressed: (){
                    final isValid = _formKey.currentState.validate();
                    if(isValid){
                      _formKey.currentState.save();
                      var formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
                      double total = widget.product.nutriments.energyKcal.toDouble() / 100 * grams.toDouble();
                      Calorie newcal = new Calorie("",widget.product.productName, total,formattedDate);
                      _addFood(userinfo.userId, newcal);
                      Navigator.of(context).pop();
                    }
                    
                  },
                ),
              ),
              SizedBox(width:10),
              Expanded(
                child: ElevatedButton(
                  child: Text("Cancel", style: TextStyle(color: kWhiteColor),),
                  style: ElevatedButton.styleFrom(primary:kRedColor),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        
        ],
      ),
    );
  }
}

Future<Widget> showFoodDetailDialog (BuildContext context, Product product, List<PieData> data)async{
  return await showDialog(
    context: context,
    builder: (BuildContext context) {  return SingleChildScrollView(child: ScanFoodDetail(product, data));},
    
  );
}