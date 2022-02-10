import 'package:flutter/material.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synonym_app/ui/leaderboard/leaderboard.dart';
import 'package:synonym_app/ui/shared/countup.dart';
import 'dart:math';

class ProgressScreen extends StatefulWidget {
  final String timedOrContinous;
  final String difficulty;
  final int totalXP;
  final int previousXP;

  const ProgressScreen({
    required this.timedOrContinous,
    required this.difficulty,
    required this.previousXP,
    required this.totalXP,
  });

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  var loggedIn = false;
  var countupXP = 0;
  var levelString = "";
  late AnimationController levelProgressController;
  var previousLevel = 0;
  var thisLevel = 0;
  var nextLevel = 0;

  xpForLevel(int level) {
    return (40 * (pow(level, 3)) / 5).floor();
  }

  levelForXP(int xp) {
    for (var i = 1; i < 300; i++) {
      var levelXP = xpForLevel(i);

      if (levelXP > xp) {
        return i - 1;
      }
    }

    return 1;
  }

  @override
  void dispose() {
    levelProgressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    previousLevel = levelForXP(widget.previousXP);
    thisLevel = levelForXP(widget.previousXP + widget.totalXP);
    nextLevel = previousLevel + 1;
    var thisLevelXP = xpForLevel(previousLevel);
    var nextLevelXP = xpForLevel(nextLevel);
    var levelXP = nextLevelXP - thisLevelXP;
    var lowerBound = (widget.previousXP - thisLevelXP) / levelXP;
    var upperBound =
        (widget.totalXP + widget.previousXP - thisLevelXP) / levelXP;
    if (upperBound < lowerBound) {
      upperBound = 1.0;
    }

    debugPrint("widget.previousXP: ${widget.previousXP}");
    debugPrint("widget.totalXP: ${widget.totalXP}");
    debugPrint("previousLevel: $previousLevel");
    debugPrint("thisLevel: $thisLevel");
    debugPrint("thisLevelXP: $thisLevelXP");
    debugPrint("nextLevel: $nextLevel");
    debugPrint("nextLevelXP: $nextLevelXP");
    debugPrint("levelXP: $levelXP");
    debugPrint("upperBound: $upperBound");
    debugPrint("lowerBound: $lowerBound");

    levelProgressController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(milliseconds: 1000),
      lowerBound: lowerBound,
      upperBound: upperBound,
    )..addListener(() {
        setState(() {});
      });

    setState(() {
      levelString = "Level $previousLevel";
      loggedIn = FirebaseAuth.instance.currentUser != null;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      levelProgressController.forward();
      setState(() {
        levelString = "Level $thisLevel";
        countupXP = widget.totalXP;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Stack(
                children: [
                  Starfield(),
                  SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 60.0,
                                  left: MediaQuery.of(context).size.width / 5.0,
                                  right:
                                      MediaQuery.of(context).size.width / 5.0),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width * 0.5,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(levelString,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: CircularProgressIndicator(
                                      value: levelProgressController.value,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.yellow),
                                      backgroundColor:
                                          Color.fromRGBO(82, 82, 82, 1.0),
                                      strokeWidth:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                                    height:
                                        MediaQuery.of(context).size.width * 0.5,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                        SizedBox(height: 80.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width) - 60,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26, blurRadius: 5)
                                    ],
                                    border: Border.all(
                                        color: Colors.white60, width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total XP",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(child: SizedBox()),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 28.0,
                                      ),
                                      Countup(
                                        begin: 0,
                                        end: countupXP.toDouble(),
                                        duration: Duration(milliseconds: 1000),
                                        separator: ',',
                                        style: TextStyle(
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 60.0),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Align(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: _tappableAnimatedContainer(
                                      'CONTINUE',
                                      Theme.of(context).secondaryHeaderColor,
                                      () => Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Leaderboard()),
                                          (_) => false),
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tappableAnimatedContainer(
      String txt, Color color, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromRGBO(37, 38, 65, 0.7),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              txt,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
