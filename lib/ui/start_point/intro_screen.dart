import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:synonym_app/ui/shared/animated_logo.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:synonym_app/ui/start_point/home.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new IntroAnimationScreen(
        screenSize: MediaQuery.of(context).size,
      ),
    );
  }
}

class IntroAnimationScreen extends StatefulWidget {
  final Size screenSize;

  IntroAnimationScreen({Key? key, required this.screenSize}) : super(key: key);

  @override
  State createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroAnimationScreen>
    with TickerProviderStateMixin {
  static const double kMinRadius = 32.0;
  static const double kMaxRadius = 128.0;
  static const double durationSlowMode = 2.0;

  late AnimationController animControlStartButton;
  late Animation fadeStartButton;
  late Size screenSize;

  RectTween createRectTween(Rect begin, Rect end) {
    return new MaterialRectArcTween(begin: begin, end: end);
  }

  @override
  void initState() {
    super.initState();

    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/backgroundsong1.mp3"),
      autoStart: true,
      showNotification: false,
    );

    screenSize = widget.screenSize;
    // Start Button
    animControlStartButton = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 150));
    fadeStartButton = new Tween(begin: 0.3, end: 1.0).animate(
        new CurvedAnimation(
            parent: animControlStartButton, curve: new Interval(0.0, 1.0)));
    fadeStartButton.addListener(() {
      setState(() {});
    });

    animControlStartButton.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animControlStartButton.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animControlStartButton.forward();
      }
    });

    animControlStartButton.forward();
  }

  @override
  void dispose() {
    animControlStartButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = durationSlowMode;

    return new Stack(
      children: <Widget>[
        new Container(
            width: double.infinity,
            height: double.infinity,
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                  Color.fromRGBO(8, 8, 24, 1.0),
                  Color.fromRGBO(8, 8, 24, 1.0)
                ],
                    begin: new FractionalOffset(0.0, 0.5),
                    end: new FractionalOffset(0.5, 1.0),
                    tileMode: TileMode.mirror)),
            child: new Starfield()),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
                alignment: Alignment.topCenter,
                child: new AnimatedLogo(
                    height: MediaQuery.of(context).size.width + 60)),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: new Opacity(
                  opacity: fadeStartButton.value,
                  child: new InkWell(
                    onTap: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Home()),
                      );
                    },
                    child: new Text(
                      'TAP TO START',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 60),
                alignment: Alignment.center,
                height: 200.0,
                width: double.infinity,
                child: Text(
                  'TM AND (C) SYNANT 2021 RIKKU WOLF STUDIOS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class RadialExpansion extends StatelessWidget {
  RadialExpansion({
    Key? key,
    required this.maxRadius,
    required this.child,
  })  : clipRectSize = 2.0 * (maxRadius / sqrt2),
        super(key: key);

  final double maxRadius;
  final clipRectSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new SizedBox(
        width: clipRectSize,
        height: clipRectSize,
        child: child,
      ),
    );
  }
}

class Photo extends StatelessWidget {
  Photo({Key? key, required this.photo, required this.color, required this.onTap}) : super(key: key);

  final String photo;
  final Color color;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        onTap: onTap,
        child: new Image.asset(
          photo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class Star {
  // angle should be value 0.0 -> 1.0
  // left 0.0 -> 360.0
  // height 0.0 -> 640.0
  // typeFade 1 -> 4

  double left;
  double top;
  double extraSize;
  double angle;
  int typeFade;

  Star(
      {required this.left,
      required this.top,
      required this.extraSize,
      required this.angle,
      required this.typeFade});
}
