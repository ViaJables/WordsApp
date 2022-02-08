import 'package:flutter/material.dart';
import 'package:synonym_app/ui/start_point/home.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synonym_app/ui/leaderboard/leaderboard_user.dart';

class Leaderboard extends StatefulWidget {

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                          Column(
                            children: [
                              SizedBox(height: 60.0),
                              Stack(
                                children: [
                                  Container(
                                     width: MediaQuery.of(context).size.width / 4,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,


                                      ),
                                    child: Image.asset(
                                        "assets/leaderboard/placeholder1.png"
                                    ),
                                  ),
                                ]
                    ),

                              Text(
                                "username",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(76, 76, 76, 0.3),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black26, blurRadius: 5)
                                  ],

                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                                ),
                                padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                                child: Text(
                                  "123432",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                    ),
                            Column(
                              children: [
                                Stack(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width / 3,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,


                                        ),
                                        child: Image.asset(
                                            "assets/leaderboard/placeholder1.png"
                                        ),
                                      ),
                                    ]
                                ),

                                Text(
                                  "username",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0),
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(76, 76, 76, 0.3),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black26, blurRadius: 5)
                                    ],

                                    borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                  ),
                                  padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                                  child: Text(
                                    "123432",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(height: 120.0),
                                Stack(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width / 4.5,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,


                                        ),
                                        child: Image.asset(
                                            "assets/leaderboard/placeholder1.png"
                                        ),
                                      ),
                                    ]
                                ),

                                Text(
                                  "username",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0),
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(76, 76, 76, 0.3),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black26, blurRadius: 5)
                                    ],

                                    borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                  ),
                                  padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                                  child: Text(
                                    "123432",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                    ],

                          ),
                    SizedBox(height: 15.0),
                    Container(

                      height: 1.0,
                        width: double.infinity,
                        color: Theme.of(context).secondaryHeaderColor,
                    ),
                        Container(

                          height: 15.0,
                          width: double.infinity,
                          color: Color.fromRGBO(37, 38, 65, 0.7),
                        ),
                        Expanded(
                          child:
                          ListView.builder(
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return LeaderboardUser();
                              }),

                        ),
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
                                              builder: (_) => Home()),
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
