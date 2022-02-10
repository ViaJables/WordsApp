import 'package:flutter/material.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synonym_app/ui/leaderboard/leaderboard_user.dart';
import 'package:synonym_app/ui/profile/help_page.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synonym_app/ui/leaderboard/leaderboard_widget.dart';

class LeaderboardHome extends StatefulWidget {
  @override
  _LeaderboardHomeState createState() => _LeaderboardHomeState();
}

class _LeaderboardHomeState extends State<LeaderboardHome> {
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

  int segmentedControlValue = 0;

  Widget segmentedControl() {
    return Container(
      width: 300,
      child: CupertinoSlidingSegmentedControl(
          groupValue: segmentedControlValue,
          backgroundColor: Colors.white.withAlpha(50),
          children: const <int, Widget>{
            0: Text('Daily'),
            1: Text('Weekly'),
            2: Text('Monthly')
          },
          onValueChanged: (value) {


            setState(() {
              segmentedControlValue = value as int;
            });
            filterUsers();
          }),
    );
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                color: Colors.white,
                                onPressed: () => Navigator.pop(context),
                              ),
                              Spacer(),
                              BouncingWidget(
                                duration: Duration(milliseconds: 30),
                                scaleFactor: 1.5,
                                onPressed: () {
                                  profilePage();
                                },
                                child: Icon(Icons.person,
                                    size: 30.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 60.0,
                          width: MediaQuery.of(context).size.width *0.8,
                          child: segmentedControl()
                        ),
                        count > 0 ?
                        Expanded(child:
                        LeaderboardWidget(userList: filteredList, myUID: myUID, filterMethod: segmentedControlValue),
                        )
                            : Expanded( child: Center(
                          child: CircularProgressIndicator(),
                        ),),



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

  profilePage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => HelpPage(),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 100),
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


      filterUsers();
      setState(() {
        count = userList.length;
      });
  });
  }

  filterUsers() {
    if (userList.length == 0) { return; }
    filteredList = userList;

    if (segmentedControlValue == 0) {
      filteredList.sort((a, b) => b.daysPoints.compareTo(a.daysPoints));
    } else if (segmentedControlValue == 1) {
      filteredList.sort((a, b) => b.weeksPoints.compareTo(a.weeksPoints));
    } else {
      filteredList.sort((a, b) => b.monthsPoints.compareTo(a.monthsPoints));
    }

    setState(() {
      count = filteredList.length;
    });
  }
}
