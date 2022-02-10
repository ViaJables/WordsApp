import 'package:flutter/material.dart';
import 'package:synonym_app/ui/start_point/home.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synonym_app/ui/leaderboard/leaderboard_widget.dart';

class Leaderboard extends StatefulWidget {

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  var loggedIn = false;
  List<LocalUser> userList = [];
  List<LocalUser> filteredList = [];
  var count = 0;
  var myUID = "";

  @override
  void initState() {
    super.initState();
    readUsers();


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
                        count > 0 ?
                        Expanded(child:
                        LeaderboardWidget(userList: filteredList, myUID: myUID, filterMethod: 0),
                        )
                            : Expanded( child: Center(
                          child: CircularProgressIndicator(),
                        ),),
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
                                              PageRouteBuilder(
                                                pageBuilder: (c, a1, a2) => Home(),
                                                transitionsBuilder: (c, anim, a2, child) =>
                                                    FadeTransition(opacity: anim, child: child),
                                                transitionDuration: Duration(milliseconds: 100),
                                              ),

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

  readUsers() async {
    FirebaseFirestore.instance.collection("users").get().then((value) {
      value.docs.forEach((element) {
        var user = LocalUser.fromMap(element.data());
        if (user.userName != "") {
          userList.add(user);
        }
      });

      var fUser = FirebaseAuth.instance.currentUser;
      if (fUser == null) { myUID = ""; } else {
        myUID = fUser.uid.toString();
      }

      if (userList.length == 0) { return; }
      filteredList = userList;
      filteredList.sort((a, b) => b.daysPoints.compareTo(a.daysPoints));
      setState(() {
        count = userList.length;
      });
    });
  }
}
