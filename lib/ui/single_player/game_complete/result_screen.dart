import 'package:flutter/material.dart';
import 'package:synonym_app/ui/start_point/home.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:synonym_app/ui/shared/grid.dart';
import 'package:synonym_app/ui/auth/login_start.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResultScreen extends StatefulWidget {
  final String timedOrContinous;
  final String difficulty;
  final int rightAns, wrongAns;

  const ResultScreen({
    @required this.timedOrContinous,
    @required this.difficulty,
    @required this.rightAns,
    @required this.wrongAns,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
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
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
                      alignment: Alignment.center,
                      height: 150.0,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          GridPainter(),
                          //AllUsers(),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        SizedBox(height: 60.0),
                        Text(
                          "RESULTS",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 25),
                        ),
                        SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width /
                                          2.0) -
                                      45,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26, blurRadius: 5)
                                    ],
                                    border: Border.all(
                                        color: Colors.white60, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "+35",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        "XP",
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width /
                                          2.0) -
                                      45,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26, blurRadius: 5)
                                    ],
                                    border: Border.all(
                                        color: Colors.white60, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "2",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        "Longest Streak",
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12),
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
                                  width: (MediaQuery.of(context).size.width /
                                          2.0) -
                                      45,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26, blurRadius: 5)
                                    ],
                                    border: Border.all(
                                        color: Colors.white60, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${widget.rightAns}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        "Correct",
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width /
                                          2.0) -
                                      45,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26, blurRadius: 5)
                                    ],
                                    border: Border.all(
                                        color: Colors.white60, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${widget.wrongAns}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        "Wrong",
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12),
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
                                            'NEXT',
                                            Theme.of(context).secondaryHeaderColor,
                                            () => Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => Home()),
                                                (_) => false),
                                          ),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      Align(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: _tappableAnimatedContainer(
                                              'QUIT',
                                              Theme.of(context).primaryColor,
                                              () =>
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              Home()),
                                                      (_) => false)),
                                        ),
                                        alignment: Alignment.centerRight,
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

  Widget _tappableAnimatedContainer(String txt, Color color, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(7)),
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
