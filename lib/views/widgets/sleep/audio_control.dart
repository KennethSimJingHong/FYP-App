import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/views/widgets/sleep/audio_widget.dart';

class AudioControl extends StatefulWidget {
  final List<Map<String, String>> items;
  AudioControl(this.items);
  @override
  _AudioControlState createState() => _AudioControlState();
}

class _AudioControlState extends State<AudioControl> {
  AudioPlayer audioPlayer;
  Duration totalDuration;
  Duration position;
  String audioState;
  String musicPlayed; 

  @override
  void initState() {
    super.initState();
    initAudio();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
  
  void initAudio(){
    audioPlayer  = new AudioPlayer();
    audioPlayer.onDurationChanged.listen((updatedDuration) {
      setState(() {
        totalDuration = updatedDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((updatedPosition) {
      setState(() {
        position = updatedPosition;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((event) {
      if (!mounted) return;
      if(event == AudioPlayerState.PLAYING){
        setState(() {
          audioState = "playing";
        });
        
      }else if(event == AudioPlayerState.STOPPED){
        setState(() {
          audioState = "stopped";
        });
        
      }else if(event == AudioPlayerState.PAUSED){
        setState(() {
          audioState = "paused";
        });
      }
    });
  }


  void playAudio(String url, String music){
    if (!mounted) return;
    audioPlayer.play(url);
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    setState(() {
      musicPlayed = music;
    });
  }

  

  void pauseAudio(){
    audioPlayer.pause();
  }

  void stopAudio(){
    audioPlayer.stop();
  }


  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 120,
        viewportFraction: 0.5,
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
      ),
      items: widget.items.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return AudioWidget(i,playAudio,pauseAudio,stopAudio,musicPlayed,audioState, totalDuration, position);
          },
        );
      }).toList(),
    );
  }
}