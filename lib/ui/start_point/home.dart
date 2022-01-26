import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/models/game.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/auth/login_start.dart';
import 'package:synonym_app/ui/multi_player/game_results.dart';
import 'package:synonym_app/ui/multi_player/multi_player_game.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:synonym_app/ui/single_player/pregame/game_difficulty_chooser.dart';
import 'package:synonym_app/ui/shared/grid.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/ui/start_point/walk_through_page.dart';
import 'package:synonym_app/ui/profile/help_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synonym_app/ui/leaderboard/leaderboard.dart';
import 'package:synonym_app/ui/start_point/home_bottom_card.dart';
import 'package:synonym_app/ui/shared/animated_logo.dart';
import 'package:synonym_app/ui/single_player/timercontroller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _animateFlag;
  var loggedIn = false;
  TimerController countdownNextHeartController = TimerController();
  int currentHeartTime = 0;

  // Ads
  RewardedAd _rewardedAd;

  @override
  void initState() {
    super.initState();

    currentHeartTime = 600;

    setState(() {
      loggedIn = FirebaseAuth.instance.currentUser != null;
      print("Logged in is $loggedIn");
    });

    Future.delayed(Keys.startAnimDuration).then((val) {
      setState(() {
        _animateFlag = true;
      });
    });

    countdownNextHeartController.setTimer(600);
    countdownNextHeartController.addListener(() {
      setState(() {
        currentHeartTime = countdownNextHeartController.timevalue;
      });
    });
  }

  _startGame() {
    Provider.of<QuestionProvider>(context, listen: false).reset();

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) =>
            GameDifficultyChooser(
              gameType: Keys.timed,
              continuous: false,
            ),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 100),
      ),
    );
  }

  format(Duration d) =>
      d
          .toString()
          .split('.')
          .first
          .padLeft(8, "0");

  @override
  void dispose() {
    countdownNextHeartController.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var user = Provider.of<LocalUser>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            new Starfield(),
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
                    HomeBottomCard(),
                    //AllUsers(),
                  ],
                ),
              ),
            ),

            Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 0, left: 30),
                              child: SizedBox(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.08,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.08,
                                child: new IconButton(
                                  icon: Icon(Icons.settings,
                                      size: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          0.08),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => HelpPage()));
                                  },
                                ),
                              ),
                            ),
                            Spacer(),

                          ],
                        ),
                        Align(
                            alignment: Alignment.topCenter,
                            child: new AnimatedLogo(
                                height: 230.0)),


                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: <Widget>[

                            SizedBox(height: 30),
                            GestureDetector(
                              onTap: () =>
                              {
                                if (loggedIn)
                                  {_startGame()}
                                else
                                  {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                WalkThroughPage()))
                                  }
                              },
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.8,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(37, 38, 65, 0.7),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(60)),
                                  border: Border.all(color: Theme
                                      .of(context)
                                      .secondaryHeaderColor, width: 1),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child:
                                Padding(
                                  padding: EdgeInsets.only(right: 15.0),
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 32.0,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "PLAY",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 25),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),


                            SizedBox(
                              height: 15,
                            ),
                            !loggedIn
                                ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginStart()));
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: 30.0,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: Center(
                                  child: Text(
                                    "login",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            )
                                : SizedBox(height: 0),


                          ],
                        ),
                        Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 3,
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection(Keys.user)
                                .doc(Provider
                                .of<LocalUser>(context)
                                .uid)
                                .collection(Keys.games)
                                .snapshots(),
                            builder: (_, snapshot) {
                              if (snapshot.data == null) return Container();

                              var list = snapshot.data.docs;

                              return ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (_, index) {
                                  GameInProgress game =
                                  GameInProgress.fromMap(list[index].data);

                                  return InkWell(
                                    onTap: () {
                                      if (game.turn == Keys.endGame)
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    GameResults(game.id)));
                                      else
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    MultiPlayerGame(game)));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme
                                                  .of(context)
                                                  .secondaryHeaderColor)),
                                      child: FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection(Keys.user)
                                            .doc(game.playingWith)
                                            .get(),
                                        builder: (context, futureSnap) {
                                          if (futureSnap.connectionState ==
                                              ConnectionState.waiting)
                                            return Container();

                                          LocalUser user = LocalUser.fromMap(
                                              futureSnap.data.data());

                                          return Row(
                                            children: <Widget>[
                                              Container(
                                                width: 5,
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width *
                                                    0.19,
                                                color:
                                                game.turn == Keys.yourTurn
                                                    ? Theme
                                                    .of(context)
                                                    .primaryColorDark
                                                    : Colors.transparent,
                                              ),
                                              SizedBox(width: 10),
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundImage:
                                                NetworkImage(user.image),
                                                backgroundColor:
                                                Theme
                                                    .of(context)
                                                    .secondaryHeaderColor,
                                              ),
                                              SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    game.turn == Keys.yourTurn
                                                        ? 'Your turn'
                                                        .toUpperCase()
                                                        : game.turn ==
                                                        Keys
                                                            .opponentsTurn
                                                        ? 'Their turn'
                                                        .toUpperCase()
                                                        : 'Results are ready'
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize:
                                                      MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width *
                                                          0.035,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: game.turn ==
                                                          Keys.yourTurn
                                                          ? Theme
                                                          .of(context)
                                                          .primaryColorDark
                                                          : Theme
                                                          .of(context)
                                                          .secondaryHeaderColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    user.name,
                                                    style: TextStyle(
                                                      fontSize:
                                                      MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width *
                                                          0.04,
                                                      color: Theme
                                                          .of(context)
                                                          .secondaryHeaderColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(child: Container()),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right:
                                                    MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width *
                                                        0.02),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Theme
                                                      .of(context)
                                                      .secondaryHeaderColor,
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.topCenter,
                height: 265.0,
                width: double.infinity,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Leaderboard()));
                      },
                      child:
                      Column(
                        children: [
                          Container(
                            height: 80.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(37, 38, 65, 0.7),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(50)),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child:
                              Image.asset(
                                "assets/leaderboard/first_place.png",
                                height: 40,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Center(
                            child: Text(
                              "Leaderboard",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Leaderboard()));
                      },
                      child:
                      Column(
                        children: [
                          Container(
                            height: 80.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(37, 38, 65, 0.7),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(50)),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 50.0,
                            ),
                          ),
                          SizedBox(height: 15),
                          Center(
                            child: Text(
                              "Next: ${format(
                                  Duration(seconds: currentHeartTime))}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20),
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
      ),
    );
  }
}
