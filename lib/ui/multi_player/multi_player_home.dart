import 'dart:convert';

import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/helpers/auth_helper.dart';
import 'package:synonym_app/models/game.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/common_widgets/page_background.dart';
import 'package:synonym_app/ui/multi_player/all_users.dart';
import 'package:synonym_app/ui/multi_player/game_results.dart';
import 'package:synonym_app/ui/multi_player/multi_player_game.dart';
import 'package:synonym_app/ui/start_point/home.dart';

class MultiPlayerHome extends StatefulWidget {
  MultiPlayerHome({Key key}) : super(key: key);

  @override
  _MultiPlayerHomeState createState() => _MultiPlayerHomeState();
}

class _MultiPlayerHomeState extends State<MultiPlayerHome> with AfterInitMixin {
  var _subscription, myUid;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didInitState() {
    myUid = Provider.of<LocalUser>(context).uid;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    return Scaffold();

    var user = Provider.of<LocalUser>(context);

    return PageBackground(
      title: 'multiplayer',
      appBarColor: Theme.of(context).primaryColorDark,
      leading: Image.asset('assets/red_go_back.png'),
      leadingTap: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Home()), (_) => false),
      trailing: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
            child: Icon(
          Icons.power_settings_new,
          size: 25,
        )),
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage('assets/base_circle.png'))),
      ),
      trailingTap: () {
        AuthHelper().signOut().then((val) {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (_) => Home()), (_) => false);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).accentColor,
                      child: user.image == ''
                          ? Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 50,
                            )
                          : null,
                      backgroundImage: user.image == ''
                          ? null
                          : MemoryImage(Base64Decoder().convert(user.image)),
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'welcome back'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        Text(
                          Provider.of<LocalUser>(context).name.toUpperCase(),
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  MaterialButton(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'start new game'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                    onPressed: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => AllUsers())),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 5)
                          ],
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(Keys.user)
                              .doc(Provider.of<LocalUser>(context).uid)
                              .collection(Keys.games)
                              .snapshots(),
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) return Container();

                            var list = snapshot.data.docs;

                            return ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (_, index) {
                                GameInProgress game =
                                    GameInProgress.fromMap(list[index].data());

                                var padding =
                                    MediaQuery.of(context).size.width * 0.4;

                                return Padding(
                                  padding: game.turn == Keys.yourTurn
                                      ? EdgeInsets.only(
                                          right: padding, bottom: 10)
                                      : EdgeInsets.only(
                                          left: padding, bottom: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: AssetImage(
                                          game.turn == Keys.yourTurn
                                              ? 'assets/blue_arrow_right.png'
                                              : 'assets/red_arrow_left.png'),
                                      fit: BoxFit.cover,
                                    )),
                                    child: ListTile(
                                      title: FutureBuilder<DocumentSnapshot>(
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

                                            String text;
                                            if (game.turn == Keys.yourTurn)
                                              text =
                                                  'Your turn with\n${user.name}';
                                            else if (game.turn ==
                                                Keys.opponentsTurn)
                                              text =
                                                  'Still waiting on\n${user.name}';
                                            else if (game.turn == Keys.endGame)
                                              text =
                                                  'Results are ready for your game with\n${user.name}';

                                            return Text(
                                              text,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            );
                                          }),
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
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
