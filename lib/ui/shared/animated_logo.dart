import 'package:flutter/material.dart';

class AnimatedLogo extends StatelessWidget {
  final double height;

  AnimatedLogo({
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return new AnimatedLogoScreen(
      height: height,
    );
  }
}

class AnimatedLogoScreen extends StatefulWidget {
  final double height;

  AnimatedLogoScreen({
    Key? key,
    required this.height
  }) : super(key: key);

  @override
  State createState() => AnimatedLogoScreenState();
}

class AnimatedLogoScreenState extends State<AnimatedLogoScreen>
    with TickerProviderStateMixin {
  late AnimationController animControlLogo;
  double height = 0.0;

  late Animation sizeLogoL1, sizeLogoL2, fadeLogoL1, fadeLogoL2;

  RectTween createRectTween(Rect begin, Rect end) {
    return new MaterialRectArcTween(begin: begin, end: end);
  }

  @override
  void initState() {
    super.initState();

    // Logo
    animControlLogo = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    fadeLogoL1 = new Tween(begin: 1.0, end: 0.0).animate(new CurvedAnimation(
        parent: animControlLogo, curve: new Interval(0.0, 1.0)));
    fadeLogoL1.addListener(() {
      setState(() {});
    });
    fadeLogoL2 = new Tween(begin: 1.0, end: 0.0).animate(new CurvedAnimation(
        parent: animControlLogo, curve: new Interval(0.0, 1.0)));
    fadeLogoL2.addListener(() {
      setState(() {});
    });
    sizeLogoL1 = new Tween(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
        parent: animControlLogo, curve: new Interval(0.2, 0.7)));
    sizeLogoL1.addListener(() {
      setState(() {});
    });
    sizeLogoL2 = new Tween(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
        parent: animControlLogo, curve: new Interval(0.2, 0.7)));
    sizeLogoL2.addListener(() {
      setState(() {});
    });

    animControlLogo.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animControlLogo.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animControlLogo.forward();
      }
    });

    // Let's go
    animControlLogo.forward();
  }

  @override
  void dispose() {
    animControlLogo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.center,
      height: widget.height,
      width: double.infinity,
      child: Stack(
        children: [
          Opacity(
              opacity: fadeLogoL1.value,
              child: Transform.translate(
                  offset: Offset(0.0, 10.0 * sizeLogoL1.value),
                  child: Image.asset('assets/SynAntL1.png',
                      width: MediaQuery.of(context).size.width))),
          Opacity(
              opacity: fadeLogoL2.value,
              child: Transform.translate(
                  offset: Offset(0.0, 5.0 * sizeLogoL2.value),
                  child: Image.asset(
                    'assets/SynAntL2.png',
                    width: MediaQuery.of(context).size.width,
                  ))),
          Image.asset(
            'assets/SynAntL3.png',
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}
