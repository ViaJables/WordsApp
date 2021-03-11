import 'dart:convert';

import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/models/game.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/models/user.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/common_widgets/help_icon.dart';
import 'package:synonym_app/ui/multi_player/new_game.dart';
import 'package:toast/toast.dart';

class AllUsers extends StatefulWidget {
  AllUsers({Key key}) : super(key: key);

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> with AfterInitMixin {
//  var _decoration;
  var _inputBorder;

  TextEditingController _searchCon;

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();

    _searchCon = TextEditingController();
  }

  @override
  void didInitState() {
//    _decoration = BoxDecoration(
//      color: Colors.white,
//      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
//      border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
//      borderRadius: BorderRadius.all(Radius.circular(7)),
//    );

    _inputBorder = OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).accentColor.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.all(Radius.circular(7)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'NEW GAME',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Multiplayer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ],
                  ),
                ),
                HelpIcon(color: Colors.white),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                  child: Container(
                    color: pageIndex == 0 ? Colors.white : Colors.transparent,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'FRIENDS',
                      style: TextStyle(
                        color: pageIndex == 0
                            ? Theme.of(context).accentColor
                            : Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  child: Container(
                    color: pageIndex == 1 ? Colors.white : Colors.transparent,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'FIND FRIENDS',
                      style: TextStyle(
                        color: pageIndex == 1
                            ? Theme.of(context).accentColor
                            : Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection(Keys.user).snapshots(),
                builder: (context, snapshot) {
                  List<User> usersList = List();

                  if (snapshot.data != null)
                    for (var item in snapshot.data.documents) {
                      var user = User.fromMap(item.data);

                      print(Provider.of<User>(context).uid);
                      if (user.uid != Provider.of<User>(context).uid)
                        usersList.add(user);
                    }

                  return Container(
                      color: Colors.white,
                      child: IndexedStack(
                        index: pageIndex,
                        children: <Widget>[
                          StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection(Keys.user)
                                .document(
                                    Provider.of<User>(context, listen: false)
                                        .uid)
                                .collection(Keys.friends)
                                .snapshots(),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );

                              List<User> friends = List();

                              for (var item in snapshot.data.documents) {
                                var user = usersList.firstWhere(
                                    (u) => u.uid == item.documentID);
                                if (user != null) friends.add(user);
                              }

                              return Column(
                                children: friends.map((item) {
                                  return _listItem(item);
                                }).toList(),
                              );
                            },
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Container(
                                  color: Colors.white,
                                  child: TextField(
                                    cursorColor: Theme.of(context).accentColor,
                                    onChanged: (st) {
                                      setState(() {});
                                    },
                                    controller: _searchCon,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      border: _inputBorder,
                                      enabledBorder: _inputBorder,
                                      focusedBorder: _inputBorder,
                                      hintText: 'Search username',
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                  ),
                                ),
                              ),
                              _searchCon.text == ''
                                  ? Container()
                                  : Column(
                                      children: usersList
                                          .where((u) => u.name
                                              .toLowerCase()
                                              .contains(_searchCon.text
                                                  .toLowerCase()))
                                          .map((item) {
                                        return _listItem(item);
                                      }).toList(),
                                    ),
                            ],
                          ),
                        ],
                      ));
                }),
          ),
        ],
      ),
    );
  }

  Widget _listItem(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        onTap: () => _startGame(user),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).accentColor,
          child: user.image == ''
              ? Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                )
              : null,
          backgroundImage: user.image == ''
              ? null
              // : MemoryImage(Base64Decoder().convert(user.image)),
              : NetworkImage(user.image),
        ),
        title: Text(
          user.name.isEmpty ? 'Fake Name' : user.name,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).primaryColor,
          size: 15,
        ),
      ),
    );
  }

  _startGame(User user) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    dialog.show();

    var result = await Firestore.instance
        .collection(Keys.user)
        .document(Provider.of<User>(context, listen: false).uid)
        .collection(Keys.games)
        .where('playingWith', isEqualTo: user.uid)
        .getDocuments();

    if (result.documents.length != 0) {
      dialog.hide();
      Toast.show('already playing with ${user.name}', context, duration: 3);
      return;
    }

    // adding as friend
    await Firestore.instance
        .collection(Keys.user)
        .document(Provider.of<User>(context, listen: false).uid)
        .collection(Keys.friends)
        .document(user.uid)
        .setData({'isFriend': true});

    await Firestore.instance
        .collection(Keys.user)
        .document(user.uid)
        .collection(Keys.friends)
        .document(Provider.of<User>(context, listen: false).uid)
        .setData({'isFriend': true});

    GameInProgress game = GameInProgress(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      playingWith: user.uid,
      turn: Keys.yourTurn,
      remainingTurns: Keys.totalTurns,
      correctAns: 0,
      wrongAns: 0,
      currentQuestion:
          await Provider.of<QuestionProvider>(context, listen: false)
              .getRandomQuestion(),
    );

    await Firestore.instance
        .collection(Keys.user)
        .document(Provider.of<User>(context, listen: false).uid)
        .collection(Keys.games)
        .document(game.id)
        .setData(game.toMap());

    game.turn = Keys.opponentsTurn;
    game.playingWith = Provider.of<User>(context, listen: false).uid;

    await Firestore.instance
        .collection(Keys.user)
        .document(user.uid)
        .collection(Keys.games)
        .document(game.id)
        .setData(game.toMap());

    game.turn = Keys.yourTurn;
    game.playingWith = user.uid;

    dialog.hide();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => NewGame(user, game)));
  }
}
