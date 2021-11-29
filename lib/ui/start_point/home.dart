import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/helpers/auth_helper.dart';
import 'package:synonym_app/models/game.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/auth/login_start.dart';
import 'package:synonym_app/ui/common_widgets/help_icon.dart';
import 'package:synonym_app/ui/multi_player/all_users.dart';
import 'package:synonym_app/ui/multi_player/game_results.dart';
import 'package:synonym_app/ui/multi_player/multi_player_game.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:synonym_app/ui/shared/animated_logo.dart';
import 'package:synonym_app/ui/single_player/word_type_chooser.dart';
import 'package:synonym_app/ui/shared/grid.dart';
import 'package:synonym_app/ui/shared/expandable_button.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/helpers/auth_helper.dart';
import 'package:synonym_app/ui/start_point/walk_through_page.dart';
import 'package:synonym_app/ui/profile/help_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synonym_app/ui/single_player/round_completed.dart';
import 'package:synonym_app/ui/leaderboard/leaderboard.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _animateFlag;
  var loggedIn = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      loggedIn = FirebaseAuth.instance.currentUser != null;
      print("Logged in is ${loggedIn}");
    });

    Future.delayed(Keys.startAnimDuration).then((val) {
      setState(() {
        _animateFlag = true;
      });
    });
  }

  _startGame(String type, String difficulty) {
    Provider.of<QuestionProvider>(context, listen: false).reset();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => WordTypeChooser(
                  gameType: type,
                  continuous: false,
                  difficulty: difficulty,
                )));
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<LocalUser>(context);

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
                    //AllUsers(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  height: 10.0,
                  width: double.infinity,
                  child: SizedBox(
                    height: 5,
                  )),
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
                            padding: EdgeInsets.only(top: 5, left: 15),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width * 0.08,
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: new IconButton(
                                icon: Icon(Icons.settings,
                                    size: MediaQuery.of(context).size.width *
                                        0.08),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => HelpPage()));
                                },
                              ),
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                                padding: EdgeInsets.only(top: 15, right: 30),
                                child: Text(
                                  "Words Game",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )

                            ),
                          ),
                  ],
                        ),


                        SizedBox(
                          height: 60,
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Align(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Container(
                                  color: Colors.transparent,
                                  child: ExpansionTileBackground(
                                    title: 'PLAY',
                                    color: Theme.of(context).accentColor,
                                    children: [
                                      ExpansionTileItem(
                                        txt: 'Easy',
                                        backgroundColor: Colors.transparent,
                                        onTap: () => {
                                          if (loggedIn)
                                            {_startGame(Keys.timed, Keys.easy)}
                                          else
                                            {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          WalkThroughPage(
                                                            difficulty:
                                                                Keys.easy,
                                                          )))
                                            }
                                        },
                                      ),
                                      ExpansionTileItem(
                                          txt: 'Medium',
                                          backgroundColor: Colors.transparent,
                                          onTap: () => {
                                                if (loggedIn)
                                                  {
                                                    _startGame(
                                                        Keys.timed, Keys.medium)
                                                  }
                                                else
                                                  {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                WalkThroughPage(
                                                                  difficulty:
                                                                      Keys.medium,
                                                                )))
                                                  }
                                              }),
                                      ExpansionTileItem(
                                          txt: 'Hard',
                                          backgroundColor: Colors.transparent,
                                          onTap: () => {
                                                if (loggedIn)
                                                  {
                                                    _startGame(
                                                        Keys.timed, Keys.hard)
                                                  }
                                                else
                                                  {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                WalkThroughPage(
                                                                  difficulty:
                                                                      Keys.hard,
                                                                )))
                                                  }
                                              }),
                                    ],
                                  ),
                                ),
                              ),
                              alignment: Alignment.bottomCenter,
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
                                      width: MediaQuery.of(context).size.width,
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
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Leaderboard()));
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: 30.0,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(
                                    "leaderboard",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection(Keys.user)
                                .doc(Provider.of<LocalUser>(context).uid)
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
                                              color: Theme.of(context)
                                                  .accentColor)),
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
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.19,
                                                color:
                                                    game.turn == Keys.yourTurn
                                                        ? Theme.of(context)
                                                            .primaryColorDark
                                                        : Colors.transparent,
                                              ),
                                              SizedBox(width: 10),
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundImage:
                                                    NetworkImage(user.image),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .accentColor,
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
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.035,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: game.turn ==
                                                              Keys.yourTurn
                                                          ? Theme.of(context)
                                                              .primaryColorDark
                                                          : Theme.of(context)
                                                              .accentColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    user.name,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(child: Container()),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Theme.of(context)
                                                      .accentColor,
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
          ],
        ),
      ),
    );
  }

  Widget _tappableAnimatedContainer(String txt, Color color, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Keys.playAnimDuration,
        color: color,
        height: 75.0,
        width: _animateFlag ? MediaQuery.of(context).size.width : 150,
        child: Center(
          child: Text(
            txt.toUpperCase(),
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPress;

  _Btn({
    @required this.text,
    @required this.color,
    @required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      padding: EdgeInsets.symmetric(vertical: 10),
      minWidth: double.infinity,
      color: color,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.width * 0.055,
        ),
      ),
    );
  }
}
