import 'package:flutter/material.dart';

class IndicatorsWidget extends StatelessWidget {
  final List data;
  IndicatorsWidget(this.data);
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data
            .map(
              (data) => Container(
                  padding: EdgeInsets.symmetric(vertical: 1),
                  child: buildIndicator(
                    color: data.color,
                    text: data.name,
                  )),
            )
            .toList(),
      );

  Widget buildIndicator({
    @required Color color,
    @required String text,
    bool isSquare = false,
    double size = 16,
    Color textColor = const Color(0xff505050),
  }) =>
      Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Roboto",
              color: textColor,
            ),
          )
        ],
      );
}