import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:synonym_app/ui/start_point/home.dart';

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

  IntroAnimationScreen({Key key, @required this.screenSize}) : super(key: key);

  @override
  State createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroAnimationScreen>
    with TickerProviderStateMixin {
  static const double kMinRadius = 32.0;
  static const double kMaxRadius = 128.0;
  static const double durationSlowMode = 2.0;

  AnimationController animControlStar, animControlStartButton, animControlLogo;

  Animation fadeAnimStar1,
      fadeAnimStar2,
      fadeAnimStar3,
      fadeAnimStar4,
      sizeAnimStar,
      rotateAnimStar;

  Animation fadeStartButton;

  Animation sizeLogoL1, sizeLogoL2, fadeLogoL1, fadeLogoL2;

  Size screenSize;
  List<Star> listStar;
  int numStars;

  RectTween createRectTween(Rect begin, Rect end) {
    return new MaterialRectArcTween(begin: begin, end: end);
  }

  Widget buildStar(
      double left, double top, double extraSize, double angle, int typeFade) {
    return new Positioned(
      child: new Container(
        child: new Transform.rotate(
          child: new Opacity(
            child: new Icon(
              Icons.star,
              color: (typeFade % 2 == 0)
                  ? Colors.white
                  : Color.fromRGBO(239, 23, 115, 1.0),
              size: sizeAnimStar.value + extraSize,
            ),
            opacity: (typeFade == 1)
                ? fadeAnimStar1.value
                : (typeFade == 2)
                    ? fadeAnimStar2.value
                    : (typeFade == 3)
                        ? fadeAnimStar3.value
                        : fadeAnimStar4.value,
          ),
          angle: angle,
        ),
        alignment: FractionalOffset.center,
        width: 10.0,
        height: 10.0,
      ),
      left: left,
      top: top,
    );
  }

  Widget buildGroupStar() {
    List<Widget> list = new List();
    for (int i = 0; i < numStars; i++) {
      list.add(buildStar(listStar[i].left, listStar[i].top,
          listStar[i].extraSize, listStar[i].angle, listStar[i].typeFade));
    }

    return new Stack(
      children: <Widget>[
        list[0],
        list[1],
        list[2],
        list[3],
        list[4],
        list[5],
        list[6],
        list[7],
        list[8],
        list[9],
        list[10],
        list[11],
        list[12],
        list[13],
        list[14],
        list[15],
        list[16],
        list[17],
        list[18],
        list[19],
        list[20],
        list[21],
        list[22],
        list[23],
        list[24],
        list[25],
        list[26],
        list[27],
        list[28],
        list[29],
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    screenSize = widget.screenSize;
    listStar = new List();
    numStars = 30;

    // Star
    animControlStar = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));
    fadeAnimStar1 = new Tween(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
        parent: animControlStar, curve: new Interval(0.0, 0.5)));
    fadeAnimStar1.addListener(() {
      setState(() {});
    });
    fadeAnimStar2 = new Tween(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
        parent: animControlStar, curve: new Interval(0.5, 1.0)));
    fadeAnimStar2.addListener(() {
      setState(() {});
    });
    fadeAnimStar3 = new Tween(begin: 1.0, end: 0.0).animate(new CurvedAnimation(
        parent: animControlStar, curve: new Interval(0.0, 0.5)));
    fadeAnimStar3.addListener(() {
      setState(() {});
    });
    fadeAnimStar4 = new Tween(begin: 1.0, end: 0.0).animate(new CurvedAnimation(
        parent: animControlStar, curve: new Interval(0.5, 1.0)));
    fadeAnimStar4.addListener(() {
      setState(() {});
    });
    sizeAnimStar = new Tween(begin: 0.0, end: 5.0).animate(new CurvedAnimation(
        parent: animControlStar, curve: new Interval(0.0, 0.5)));
    sizeAnimStar.addListener(() {
      setState(() {});
    });
    rotateAnimStar = new Tween(begin: 0.0, end: 1.0).animate(
        new CurvedAnimation(
            parent: animControlStar, curve: new Interval(0.0, 0.5)));
    rotateAnimStar.addListener(() {
      setState(() {});
    });

    animControlStar.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animControlStar.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animControlStar.forward();
      }
    });

    for (int i = 0; i < numStars; i++) {
      listStar.add(new Star(
          left: new Random().nextDouble() * screenSize.width,
          top: Random().nextDouble() * screenSize.height,
          extraSize: Random().nextDouble() * 2,
          angle: Random().nextDouble(),
          typeFade: Random().nextInt(4)));
    }

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

    // Logo
    animControlLogo = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 200));
    fadeLogoL1 = new Tween(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
        parent: animControlLogo, curve: new Interval(0.2, 0.7)));
    fadeLogoL1.addListener(() {
      setState(() {});
    });
    fadeLogoL2 = new Tween(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
        parent: animControlLogo, curve: new Interval(0.2, 0.7)));
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
    animControlStar.forward();
    animControlLogo.forward();
    animControlStartButton.forward();
  }

  @override
  void dispose() {
    animControlStar.dispose();
    animControlLogo.dispose();
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
            child: buildGroupStar()),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width + 60.0,
                width: double.infinity,
                child: Stack(
                  children: [
                    Transform.translate(
                        offset: Offset(0.0, 10.0 * sizeLogoL1.value),
                        child: Image.asset('assets/SynAntL1.png',
                            width: MediaQuery.of(context).size.width)),
                    Transform.translate(
                        offset: Offset(0.0, 5.0 * sizeLogoL2.value),
                        child: Image.asset(
                          'assets/SynAntL2.png',
                          width: MediaQuery.of(context).size.width,
                        )),
                    Image.asset(
                      'assets/SynAntL3.png',
                      width: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: new Opacity(
                  opacity: fadeStartButton.value,
                  child: new InkWell(
                    onTap: () {
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
    Key key,
    this.maxRadius,
    this.child,
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
  Photo({Key key, this.photo, this.color, this.onTap}) : super(key: key);

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
      {@required this.left,
      @required this.top,
      @required this.extraSize,
      @required this.angle,
      @required this.typeFade});
}
