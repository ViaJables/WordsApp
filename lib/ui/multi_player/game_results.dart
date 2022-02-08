import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/models/game.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/common_widgets/custom_button.dart';
import 'package:synonym_app/ui/start_point/home.dart';

class GameResults extends StatefulWidget {
  final String gameId;

  GameResults(this.gameId);

  @override
  _GameResultsState createState() => _GameResultsState();
}

class _GameResultsState extends State<GameResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Container(),
                  onPressed: null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'RESULTS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Container(),
                  onPressed: null,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection(Keys.completedGames)
                      .doc(widget.gameId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text(
                              'Please wait...\nGetting results',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    CompletedGame game =
                        CompletedGame.fromMap(snapshot.data!.data() as Map<String, dynamic>);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset(
                          'assets/you_won.png',
                          width: MediaQuery.of(context).size.width * 0.65,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _scoreRow(
                                "",
                                game.userAResult.name,
                                game.userBResult.name,
                              ),
                              _scoreRow(
                                'Total Right',
                                game.userAResult.correctAns.toString(),
                                game.userBResult.correctAns.toString(),
                              ),
                              Divider(),
                              _scoreRow(
                                'Total Wrong',
                                game.userAResult.wrongAns.toString(),
                                game.userBResult.wrongAns.toString(),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: <Widget>[
                              CustomButton(
                                text: 'REMATCH',
                                color: Theme.of(context).primaryColor,
                                onTap: () {},
                              ),
                              SizedBox(height: 10),
                              CustomButton(
                                text: 'MENU',
                                color: Theme.of(context).primaryColorDark,
                                onTap: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (_) => Home()),
                                    (_) => false,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreRow(String text1, String text2, String text3) {
    final boldStyle = TextStyle(
        color: Theme.of(context).secondaryHeaderColor,
        fontSize: 22,
        fontWeight: FontWeight.bold);

    final lightBoldStyle = TextStyle(
      color: Theme.of(context).secondaryHeaderColor,
      fontSize: 20,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: text1 == null
                ? Container()
                : Text(
                    text1,
                    style: lightBoldStyle,
                  ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                text2.split(' ')[0],
                style: text1 == null ? boldStyle : lightBoldStyle,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                text3.split(' ')[0],
                style: text1 == null ? boldStyle : lightBoldStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _rematch(CompletedGame game) async {
    Navigator.pop(context);

    await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(Provider.of<LocalUser>(context, listen: false).uid)
        .collection(Keys.games)
        .doc(widget.gameId)
        .delete();

    /*
    var playingWith = Provider.of<User>(context, listen: false).uid == game.userAUid? game.userAUid: game.userBUid;

    GameInProgress newGame = GameInProgress(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      playingWith: playingWith,
      turn: Keys.yourTurn,
      remainingTurns: Keys.totalTurns,
      correctAns: 0,
      wrongAns: 0,
      currentQuestion:
      Provider.of<QuestionNotifier>(context, listen: false).randomQuestion,
    );

    await Firestore.instance
        .collection(Keys.user)
        .document(Provider.of<User>(context, listen: false).uid)
        .collection(Keys.games)
        .document(newGame.id)
        .setData(newGame.toMap());

    newGame.turn = Keys.opponentsTurn;
    newGame.playingWith = Provider.of<User>(context, listen: false).uid;

    await Firestore.instance
        .collection(Keys.user)
        .document(newGame.playingWith)
        .collection(Keys.games)
        .document(newGame.id)
        .setData(newGame.toMap());

    newGame.turn = Keys.yourTurn;
    newGame.playingWith = user.uid;

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => NewGame(user, game)));

     */
  }
}
