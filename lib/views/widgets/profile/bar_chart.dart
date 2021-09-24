import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/models/chart.dart';

class ProfileBarChart extends StatefulWidget {
  final List<Color> colors;
  final String typeChart;
  final List<Chart> weeklyData;
  final Function updateMaxY, getInterval;
  ProfileBarChart(this.colors, this.typeChart, this.weeklyData, this.updateMaxY, this.getInterval);
  @override
  _ProfileBarChartState createState() => _ProfileBarChartState();
}

class _ProfileBarChartState extends State<ProfileBarChart> {

  double maxY = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:15, horizontal: 30),
      margin:EdgeInsets.symmetric(horizontal:20, vertical:2),
      decoration: BoxDecoration(
        border: Border.all(width:2, color:kWhiteColor),
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.colors
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0.0,2.0),
            color: Colors.black26,
          ),
        ],
      ),
      height:200,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            
            child: Text(widget.typeChart, style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "Roboto", letterSpacing: 1)),
          ),
          
          SizedBox(height:20),
          Expanded(
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show:false),
                alignment: BarChartAlignment.spaceEvenly,
                minY: 0.toDouble(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: kWhiteColor.withOpacity(0.7),
                    tooltipPadding: EdgeInsets.all(5),
                  )
                ),
                titlesData: FlTitlesData(
                  bottomTitles: 
                    SideTitles(
                      showTitles: true,
                      getTextStyles: (val) => TextStyle(color:kWhiteColor, fontSize:12, fontWeight: FontWeight.bold),
                      getTitles: (double id) => widget.weeklyData.firstWhere((element) => element.id == id.toInt()).name,
                    ),
                  leftTitles: 
                  SideTitles(
                    showTitles: true,
                    getTextStyles: (val) => TextStyle(color:kWhiteColor, fontSize:12, fontWeight: FontWeight.bold),
                    interval: widget.getInterval(widget.updateMaxY(widget.weeklyData, maxY)),
                  ),
                ),

                barGroups: widget.weeklyData
                  .map(
                    (e) => BarChartGroupData(
                      x: e.id,
                      barRods: [
                        BarChartRodData(
                          y: e.y.toDouble(),
                          width: 12,
                          colors: [e.color],
                          borderRadius: BorderRadius.circular(3),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            y: widget.updateMaxY(widget.weeklyData, maxY),
                            colors: [e.color.withOpacity(0.3)]
                          )
                        ),
                      ]
                  )
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}