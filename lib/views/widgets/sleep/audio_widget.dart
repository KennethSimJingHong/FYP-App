import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';

class AudioWidget extends StatefulWidget {
  final Map<String,String> i;
  final Function playAudio, pauseAudio, stopAudio;
  final String musicPlayed, audioState;
  final Duration totalDuration, position;
  AudioWidget(this.i, this.playAudio, this.pauseAudio, this.stopAudio, this.musicPlayed, this.audioState, this.totalDuration, this.position);
  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0.0,2.0),
            color:Colors.black26,
          ),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(widget.i["title"], style: TextStyle(fontSize: 18.0, fontFamily: "Roboto", fontWeight: FontWeight.bold),),
              SizedBox(height:6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.musicPlayed == widget.i["title"] && widget.audioState == "playing"? 
                  OutlinedButton.icon(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 2.0, color: kGreenColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: ()=>widget.pauseAudio(), icon: Icon(Icons.pause, color: kGreenColor), label: Text("Pause", style:TextStyle(color: kGreenColor))) :
                  
                  OutlinedButton.icon(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 2.0, color: kGreenColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: ()=>widget.playAudio(widget.i["url"], widget.i["title"]), icon: Icon(Icons.play_arrow, color: kGreenColor,), label: Text("Play", style:TextStyle(color: kGreenColor))),
                  
                 
                ],
              ),
              widget.musicPlayed == widget.i["title"] && widget.audioState != "stopped" ? 
              Padding(
                padding: const EdgeInsets.only(top:10.6),
                child: Text("${widget.position}".split(".").first + " -- " + "${widget.totalDuration}".split(".").first),
              ) : Container(),
            ],
          ),
        ),
      )
    );
  }
}