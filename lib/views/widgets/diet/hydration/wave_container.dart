import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class WaveContainer extends StatefulWidget {
  final AnimationController controller;
  final double current;
  final double total;
  WaveContainer(this.controller,this.current, this.total);

  @override
  _WaveContainerState createState() => _WaveContainerState();

}

class _WaveContainerState extends State<WaveContainer> with SingleTickerProviderStateMixin {
  Animation<double> animation;


  @override
  void initState() {
    super.initState();
      animation = Tween<double>(begin: -500, end: 0).animate(widget.controller);
  }


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedBuilder(
            animation: widget.controller,
            builder: (BuildContext context, Widget child) {  
              return Positioned(
                left: animation.value,
                bottom:0,
                child: ClipPath(
                  clipper: WaterClipper(),
                    child: Container(
                    height:100 * widget.current/widget.total > 100 ? 210 : 210  * widget.current/widget.total,
                    width:2000,
                    color:Color(0xFF96E5D2),
                  ),
                ),
              );
            },
          ),
             
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black45.withOpacity(0.25), BlendMode.srcOut),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Center(
                  child: Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class WaterClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
      Path path = new Path();    
      path.moveTo(0, size.height - (size.height - 15));
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, size.height - (size.height - 15));
      path.cubicTo(size.width*0.916, 0, size.width*0.832, size.height - (size.height - 30), size.width*0.748, size.height - (size.height - 15));
      path.cubicTo(size.width*0.664, 0, size.width*0.58,size.height - (size.height - 30), size.width*0.496,size.height - (size.height - 15));
      path.cubicTo(size.width*0.412, 0, size.width*0.328,size.height - (size.height - 30), size.width*0.244,size.height - (size.height - 15));
      path.cubicTo(size.width*0.16, 0, size.width*0.076,size.height - (size.height - 30), 0, size.height - (size.height - 15));
      return path;
    }
    @override
    bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
      return true;
  }
}



