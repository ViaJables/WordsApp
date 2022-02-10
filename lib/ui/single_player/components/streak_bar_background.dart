import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { color1, color2 }

class StreakBarBackground extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final tween = MultiTween<AniProps>();
    tween.add(AniProps.color1, ColorTween(begin: Theme.of(context).primaryColor, end: Colors.white), Duration(seconds: 3) );
    tween.add(AniProps.color2, ColorTween(begin: Theme.of(context).secondaryHeaderColor, end: Colors.white), Duration(seconds: 3));

    return MirrorAnimation(
      tween: tween,
      duration: tween.duration,
      builder: (context, child, value) {

        return Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5)
              ],
              border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 3),
              borderRadius: BorderRadius.all(
                  Radius.circular(25)),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Theme.of(context).primaryColor, Theme.of(context).secondaryHeaderColor])),
        );
      }
    );
  }
}