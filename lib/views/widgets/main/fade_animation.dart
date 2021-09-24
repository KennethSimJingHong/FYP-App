// import 'dart:async';

import 'package:simple_animations/simple_animations.dart';
import 'package:flutter/material.dart';

enum AnimationProps {opacity, translate}


class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  final String trans;
  FadeAnimation(this.delay,this.trans, this.child);

  @override
  Widget build(BuildContext context) {
    final _tween = MultiTween<AnimationProps>()
      ..add(AnimationProps.opacity, Tween(begin: 0.0, end: 1.0), Duration(milliseconds: 500))
      ..add(AnimationProps.translate, Tween(begin: -30.0, end: 0.0), Duration(milliseconds: 500), Curves.easeOut);

    return PlayAnimation<MultiTweenValues<AnimationProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      tween: _tween,
      duration:_tween.duration,
      child: child,
      builder: (context, child, value){
        return Opacity(
          opacity: value.get(AnimationProps.opacity),
          child: Transform.translate(
            offset: trans == "x" ? Offset(value.get(AnimationProps.translate), 0) : Offset( 0,value.get(AnimationProps.translate)),
            child: child,
          ),
        );
      },
    );
  }
}
