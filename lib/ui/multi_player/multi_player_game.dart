import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/models/game.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/models/result.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/multi_player/game_results.dart';

class MultiPlayerGame extends StatefulWidget {
  final GameInProgress game;

  MultiPlayerGame(this.game);

  @override
  _MultiPlayerGameState createState() => _MultiPlayerGameState();
}

class _MultiPlayerGameState extends State<MultiPlayerGame> {
  late GameInProgress _game;
  late Question _currentQuestion;

  var _subscription;

  @override
  void initState() {
    super.initState();

    _game = widget.game;
    _currentQuestion = _game.currentQuestion;

    _subscription = FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(Provider.of<LocalUser>(context, listen: false).uid)
        .collection(Keys.games)
        .doc(_game.id)
        .snapshots()
        .listen((val) {
      _game = GameInProgress.fromMap(val.data() as Map<String, dynamic>);

      setState(() {
        _currentQuestion = _game.currentQuestion;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentQuestion.synonymOrAntonym == Keys.synonym
          ? Theme.of(context).primaryColor
          : Theme.of(context).primaryColorDark,
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // SizedBox(width: MediaQuery.of(context).size.width /3.5,),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: <Widget>[
                        Text(
                          _currentQuestion.word,
                          // 'jasbdjabsdjbas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.07,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _currentQuestion.synonymOrAntonym,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.pause),
                //   color: Colors.white,
                //   onPressed: () {},
                // ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _MarksBox(_game.correctAns.toString(), 's'),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: _MarksBox(_game.wrongAns.toString(), 's'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: _game.currentQuestion.synonymOrAntonym ==
                                    Keys.antonym
                                ? Theme.of(context).primaryColorDark
                                : Theme.of(context).primaryColor,
                            width: 4,
                          ),
                          color: _game.turn == Keys.yourTurn
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.3)),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        _game.turn == Keys.yourTurn
                            ? 'Your turn'.toUpperCase()
                            : 'Their turn'.toUpperCase(),
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.055,
                          fontWeight: FontWeight.bold,
                          color: _game.currentQuestion.synonymOrAntonym ==
                                  Keys.antonym
                              ? Theme.of(context).primaryColorDark
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(children: _answersUI()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _answersUI() {
    int count;
    count = 4;
   // width = MediaQuery.of(context).size.width / 1.5;

    List<Widget> output = [];

    for (int i = 0; i < count; i++) {
      var wid = Expanded(
        child: Dismissible(
          key: Key('${_currentQuestion.id}/$i'),
          //direction: _game.turn == Keys.yourTurn
           //   ? i % 2 == 0
            //      ? DismissDirection!.startToEnd
            //      : DismissDirection!.endToStart
            //  : null,
          onDismissed: _game.turn == Keys.yourTurn
              ? (dir) {
                  _handleSwipe(_currentQuestion.answers[i]);
                }
              : null,
          child: Stack(
            children: <Widget>[
              Align(
                alignment:
                    i % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
                child: Image.asset(
                  _currentQuestion.synonymOrAntonym == Keys.synonym
                      ? i % 2 == 0
                          ? 'assets/arrow_left_blue.png'
                          : 'assets/arrow_right_blue.png'
                      : i % 2 == 0
                          ? 'assets/arrow_left_red.png'
                          : 'assets/arrow_right_red.png',
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
              Align(
                alignment: i % 2 == 0 ? Alignment(-0.6, 0) : Alignment(0.6, 0),
                child: Text(
                  _currentQuestion.answers[i].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
//              child: Container(
//                height: MediaQuery.of(context).size.height * 0.2,
//                width: width,
//                child: Center(
//                  child: Text(
//                    _currentQuestion.answers[i].toUpperCase(),
//                    style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 25,
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
//                ),
//                decoration: BoxDecoration(
//                  image: DecorationImage(
//                      image: _currentQuestion.synonymOrAntonym == Keys.synonym
//                          ? AssetImage(i % 2 == 0
//                              ? 'assets/arrow_left_blue.png'
//                              : 'assets/arrow_right_blue.png')
//                          : AssetImage(i % 2 == 0
//                              ? 'assets/arrow_left_red.png'
//                              : 'assets/arrow_right_red.png'),
//                      fit: BoxFit.cover),
//                ),
//              ),
        ),
      );
      output.add(wid);
    }
    return output;
  }

//  _pickQuestion() async {
//    var ques = await Provider.of<QuestionProvider>(context, listen: false)
//        .getRandomQuestion();
//    setState(() {
//      _currentQuestion = ques;
//    });
//  }

  _handleSwipe(String answer) async {
    String id = _game.id;

    if (_game.remainingTurns - 1 == 0) {
      var opponentData = await FirebaseFirestore.instance
          .collection(Keys.user)
          .doc(_game.playingWith)
          .collection(Keys.games)
          .doc(id)
          .get();

      if (opponentData.data()!['remainingTurns'] == 0) {
        await _finishGame(GameInProgress.fromMap(opponentData.data() as Map<String, dynamic>));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => GameResults(_game.id)));
        return;
      }
    }

    Question question =
        await Provider.of<QuestionProvider>(context, listen: false)
            .getRandomQuestion();

    GameInProgress currentUserGameObject = GameInProgress(
      id: id,
      playingWith: _game.playingWith,
      turn: _game.turn == Keys.yourTurn ? Keys.opponentsTurn : Keys.yourTurn,
      remainingTurns: _game.remainingTurns - 1,
      correctAns:
          answer == _currentQuestion.answers[_currentQuestion.correctAnswer]
              ? _game.correctAns + 1
              : _game.correctAns,
      wrongAns:
          answer != _currentQuestion.answers[_currentQuestion.correctAnswer]
              ? _game.wrongAns + 1
              : _game.wrongAns,
      currentQuestion: question,
    );

    await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(Provider.of<LocalUser>(context, listen: false).uid)
        .collection(Keys.games)
        .doc(id)
        .update(currentUserGameObject.toMap());

    await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(_game.playingWith)
        .collection(Keys.games)
        .doc(id)
        .update({
      'playingWith': Provider.of<LocalUser>(context, listen: false).uid,
      'currentQuestion': question.toMap(),
      'turn': _game.turn == Keys.yourTurn ? Keys.opponentsTurn : Keys.yourTurn,
    });
  }

  _finishGame(GameInProgress opponentGameData) async {
    await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(Provider.of<LocalUser>(context, listen: false).uid)
        .collection(Keys.games)
        .doc(_game.id)
        .update({'turn': Keys.endGame});

    await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(_game.playingWith)
        .collection(Keys.games)
        .doc(_game.id)
        .update({'turn': Keys.endGame});

    Result resultUserA = Result(
      uid: Provider.of<LocalUser>(context, listen: false).uid,
      name: Provider.of<LocalUser>(context, listen: false).name,
      correctAns: _game.correctAns,
      wrongAns: _game.wrongAns,
    );

    Result resultUserB = Result(
      uid: _game.playingWith,
      name: (await FirebaseFirestore.instance
              .collection(Keys.user)
              .doc(_game.playingWith)
              .get())
          .data()!['name'],
      correctAns: opponentGameData.correctAns,
      wrongAns: opponentGameData.wrongAns,
    );

    String winner;
    if (_game.correctAns == opponentGameData.correctAns)
      winner = '';
    else if (_game.correctAns > opponentGameData.correctAns)
      winner = Provider.of<LocalUser>(context, listen: false).uid;
    else
      winner = _game.playingWith;

    CompletedGame completedGame = CompletedGame(
      userAUid: Provider.of<LocalUser>(context, listen: false).uid,
      userBUid: _game.playingWith,
      winnerUid: winner,
      userAResult: resultUserA,
      userBResult: resultUserB,
    );

    await FirebaseFirestore.instance
        .collection(Keys.completedGames)
        .doc(_game.id)
        .set(completedGame.toMap());
  }
}

class _MarksBox extends StatelessWidget {
  final String marks;
  final String image;

  _MarksBox(this.marks, this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Theme.of(context).secondaryHeaderColor,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(image),
          ),
          SizedBox(width: 15),
          Text(
            marks,
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
