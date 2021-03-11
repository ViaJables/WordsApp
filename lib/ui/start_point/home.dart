import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/helpers/auth_helper.dart';
import 'package:synonym_app/models/game.dart';
import 'package:synonym_app/models/user.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/auth/login.dart';
import 'package:synonym_app/ui/common_widgets/help_icon.dart';
import 'package:synonym_app/ui/multi_player/all_users.dart';
import 'package:synonym_app/ui/multi_player/game_results.dart';
import 'package:synonym_app/ui/multi_player/multi_player_game.dart';
import 'package:synonym_app/ui/single_player/game_difficulty_chooser.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _animateFlag;

  @override
  void initState() {
    super.initState();

    _animateFlag = false;

    Future.delayed(Keys.startAnimDuration).then((val) {
      setState(() {
        _animateFlag = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
              SizedBox(
                height: 60,
              ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          'assets/logo.png',
                          width: MediaQuery.of(context).size.width * 0.6,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'welcome back\n${user.name}'.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'start a new game'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width * 0.05,
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              _Btn(
                                text: 'single player',
                                color: Theme.of(context).primaryColor,
                                onPress: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => GameDifficultyChooser())),
                              ),
                              SizedBox(height: 10),
                              _Btn(
                                text: 'multiplayer',
                                color: Theme.of(context).primaryColorDark,
                                onPress: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => AllUsers()));
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              IconButton(
                                icon: Icon(Icons.power_settings_new),
                                onPressed: () async {
                                  AuthHelper().signOut().then((val) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (_) => Login()),
                                        (_) => false);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Your current games'.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: StreamBuilder(
                            stream: Firestore.instance
                                .collection(Keys.user)
                                .document(Provider.of<User>(context).uid)
                                .collection(Keys.games)
                                .snapshots(),
                            builder: (_, snapshot) {
                              if (snapshot.data == null) return Container();

                              var list = snapshot.data.documents;

                              return ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (_, index) {
                                  GameInProgress game =
                                      GameInProgress.fromMap(list[index].data);

                                  return InkWell(
                                    onTap: () {
                                      if (game.turn == Keys.endGame)
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => GameResults(game.id)));
                                      else
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => MultiPlayerGame(game)));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme.of(context).accentColor)),
                                      child: FutureBuilder<DocumentSnapshot>(
                                        future: Firestore.instance
                                            .collection(Keys.user)
                                            .document(game.playingWith)
                                            .get(),
                                        builder: (context, futureSnap) {
                                          if (futureSnap.connectionState ==
                                              ConnectionState.waiting)
                                            return Container();

                                          User user =
                                              User.fromMap(futureSnap.data.data);

                                          return Row(
                                            children: <Widget>[
                                              Container(
                                                width: 5,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.19,
                                                color: game.turn == Keys.yourTurn
                                                    ? Theme.of(context)
                                                        .primaryColorDark
                                                    : Colors.transparent,
                                              ),
                                              SizedBox(width: 10),
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundImage: NetworkImage(user.image),
                                                backgroundColor:
                                                    Theme.of(context).accentColor,
                                              ),
                                              SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    game.turn == Keys.yourTurn
                                                        ? 'Your turn'.toUpperCase()
                                                        : game.turn ==
                                                                Keys.opponentsTurn
                                                            ? 'Their turn'
                                                                .toUpperCase()
                                                            : 'Results are ready'
                                                                .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.035,
                                                      fontWeight: FontWeight.bold,
                                                      color:
                                                          game.turn == Keys.yourTurn
                                                              ? Theme.of(context)
                                                                  .primaryColorDark
                                                              : Theme.of(context)
                                                                  .accentColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    user.name,
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context)
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
                                                    right: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.02),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color:
                                                      Theme.of(context).accentColor,
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
            AllThree(),
          ],
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
