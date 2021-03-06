import 'package:flutter/material.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:synonym_app/ui/auth/login_start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synonym_app/ui/single_player/game_complete/progress_screen.dart';
import 'package:synonym_app/ui/shared/countup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:synonym_app/res/keys.dart';

class RoundCompleted extends StatefulWidget {
  final String timedOrContinous;
  final String difficulty;
  final int earnedXP;
  final int streakXP;
  final int remainingLives;
  final int streakLength;

  const RoundCompleted({
    required this.timedOrContinous,
    required this.difficulty,
    required this.earnedXP,
    required this.streakXP,
    required this.remainingLives,
    required this.streakLength
  });

  @override
  _RoundCompletedState createState() => _RoundCompletedState();
}

class _RoundCompletedState extends State<RoundCompleted> {
  var loggedIn = false;
  @override
  void initState() {
    super.initState();

    setState(() {
      loggedIn = FirebaseAuth.instance.currentUser != null;
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
                        SizedBox(height: 80.0),
                        Text(
                          "COMPLETED",
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.normal,
                              fontSize: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.075),
                        ),
                        Text(
                          "ROUND",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.2),
                        ),
                        SizedBox(height: 60.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width) -
                                      60,

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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Round XP",
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
                                      Expanded(
                                        child: SizedBox()
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 28.0,
                                      ),
                                      Countup(
                                        begin: 0,
                                        end: widget.earnedXP.toDouble(),
                                        duration: Duration(milliseconds: 250),
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
                        SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width) -
                                      60,

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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Streak XP",
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
                                      Expanded(
                                          child: SizedBox()
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 28.0,
                                      ),
                                      Countup(
                                        begin: 0,
                                        end: widget.streakXP.toDouble(),
                                        duration: Duration(milliseconds: 250),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width) -
                                      60,

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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Remaining Lives",
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
                                      Expanded(
                                          child: SizedBox()
                                      ),
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 28.0,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        "${widget.remainingLives}",
                                        style: TextStyle(
                                          color: Colors.red,
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
                        !loggedIn
                            ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Align(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: _tappableAnimatedContainer(
                                      'SAVE AND BEGIN',
                                      Theme.of(context).secondaryHeaderColor,
                                          () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  LoginStart())),
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              ],
                            ),
                          ),
                        )
                            : Align(
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
                                          () => { continueTapped(context) }
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

  Future continueTapped(BuildContext context) async {
    var user = await _getUser();
    var lastXP = user.xpPoints;
    var newXP = user.xpPoints + widget.earnedXP + widget.streakXP;
    user.lives = widget.remainingLives;
    user.xpPoints = newXP;
    user.daysPoints = user.daysPoints + widget.earnedXP + widget.streakXP;
    user.weeksPoints = user.weeksPoints + widget.earnedXP + widget.streakXP;
    user.monthsPoints = user.monthsPoints + widget.earnedXP + widget.streakXP;
    if (widget.streakLength > user.longestStreak) { user.longestStreak = widget.streakLength; }



    await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(user.uid)
        .update(user.toMap());

    var route = PageRouteBuilder(
      pageBuilder: (c, a1, a2) => ProgressScreen(
        timedOrContinous: widget.timedOrContinous,
        difficulty: widget.difficulty,
        totalXP: widget.streakXP + widget.earnedXP,
        previousXP: lastXP,
      ),
      transitionsBuilder: (c, anim, a2, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: Duration(milliseconds: 100),
    );

    Navigator.pushAndRemoveUntil(
        context,
        route,
            (_) => false);

  }

  Future<LocalUser> _getUser() async {
    LocalUser user = LocalUser.fromMap((await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get())
        .data()!);
    return user;
  }

  Widget _tappableAnimatedContainer(String txt, Color color, Function()? onTap) {
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
