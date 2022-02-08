import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedLogo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(
            'Synonym',
            textStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.175,
              fontWeight: FontWeight.bold,
            ),
            colors: [Theme.of(context).secondaryHeaderColor, Colors.yellow, Theme.of(context).primaryColor],
          ),
          ColorizeAnimatedText(
            'Antonym',
            textStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.175,
              fontWeight: FontWeight.w800,
            ),
            colors: [Theme.of(context).primaryColor, Colors.yellow, Theme.of(context).secondaryHeaderColor],
          ),
        ],
        isRepeatingAnimation: true,
    );
  }
}

