import 'package:flutter/material.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synonym_app/ui/leaderboard/leaderboard.dart';
import 'package:countup/countup.dart';

class ProgressScreen extends StatefulWidget {
  final String timedOrContinous;
  final String difficulty;
  final int totalXP;

  const ProgressScreen({
    @required this.timedOrContinous,
    @required this.difficulty,
    @required this.totalXP,
  });

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
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
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(top: 60.0, left: MediaQuery.of(context).size.width / 5.0, right: MediaQuery.of(context).size.width / 5.0),
                              child: Stack(
                                children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.5,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child:
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text( 'Level 3', style:
                                      TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                    ],
                                  ),
                                ),
                                  SizedBox(
                                    child: CircularProgressIndicator(
                                      value: 0.5,
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow),
                                      backgroundColor: Color.fromRGBO(82, 82, 82, 1.0),
                                      strokeWidth: MediaQuery.of(context).size.width * 0.05,
                                    ),
                                    height: MediaQuery.of(context).size.width * 0.5,
                                    width: MediaQuery.of(context).size.width * 0.5,
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
                                        end: widget.totalXP.toDouble(),
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

  Widget _tappableAnimatedContainer(String txt, Color color, Function onTap) {
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
