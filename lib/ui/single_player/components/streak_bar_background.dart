import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { color1, color2 }

class StreakBarBackground extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final tween = MultiTween<AniProps>();
    tween.add(AniProps.color1, ColorTween(begin: Colors.red, end: Colors.blue), Duration(seconds: 3) );
    tween.add(AniProps.color2, ColorTween(begin: Colors.purple, end: Colors.green), Duration(seconds: 3));

    return MirrorAnimation(
      tween: tween,
      duration: tween.duration,
      builder: (context, child, value) {

        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red, Colors.green])),
        );
      }
    );
  }
}