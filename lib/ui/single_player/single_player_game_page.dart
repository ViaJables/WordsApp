import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:synonym_app/ui/single_player/timercontroller.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/res/constants.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/single_player/pause_screen.dart';
import 'package:synonym_app/ui/single_player/game_complete/round_completed.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:synonym_app/ui/shared/grid.dart';
import 'package:flutter/services.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:synonym_app/ui/shared/countup.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synonym_app/helpers/auth_helper.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:synonym_app/ui/single_player/components/streak_bar.dart';

class SinglePlayerGamePage extends StatefulWidget {
  final String gameType;
  final String difficulty;
  final bool continuous;
  final String wordType;

  SinglePlayerGamePage({
    required this.gameType,
    required this.wordType,
    this.difficulty = Keys.medium,
    this.continuous = false,
  });

  @override
  _SinglePlayerGamePageState createState() => _SinglePlayerGamePageState();
}

class _SinglePlayerGamePageState extends State<SinglePlayerGamePage>
    with TickerProviderStateMixin<SinglePlayerGamePage> {
  bool loading = false;

  // Data
  late Question? _currentQuestion = null;
  var hasQuestion = false;
  List<String> usedquestionslist = [];
  List<String> answers = [];
  String answer = "";
  List<Question> questionsList = [];



  // Time
  int _currentTime = 0, _pausedTime = 0;
  late Timer t;
  String mix = 'synonym';
  bool _animateFlag = false;

  // Timer tim.timevalue;
  List<Widget> output = [];
  Key x = UniqueKey();

  // Layout
  double width = 0.0;
  double answerHeight = 0.0;
  double answerPadding = 0.0;
  int count = 0;
  int pointsPerQuestion = 0;

  int index = -1;
  late LocalUser user;

  int a = 0;
  var tim, tim2;
  TimerController timeController = TimerController();
  var timerListener;

  // Streaks
  var streakLength = 0;
  var streakPoints = 0.0;
  var longestStreak = 0;
  GlobalKey<StreakBarState> _streakBarKey = GlobalKey();


  // Stats
  var points = 0.0;
  var regularPoints = 0.0;

  var lastPoints = 0.0;

  var remainingLives = 3;
  var remainingBombs = 3;
  var remainingClocks = 3;
  var remainingHourglasses = 3;


  @override
  void initState() {
    super.initState();

    fetchStoredUser();
    fetchUser();
    readQuestions();
    _animateFlag = false;
    print("Single player init called");
    _currentTime = 60;
    timeController.setTimer(_currentTime);


    timerListener = () {
      setState(() {
        _currentTime = timeController.timevalue;

        if (_currentTime < 1) {
          completeRound();
        }
      });
    };

    timeController.addListener(timerListener);


    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (widget.difficulty == Keys.easy) {
        count = 2;
        pointsPerQuestion = 20;
        answerHeight = (MediaQuery.of(context).size.height - 600) / 2.0;
        answerPadding = 30.0;
      } else if (widget.difficulty == Keys.medium) {
        count = 3;
        pointsPerQuestion = 35;
        answerHeight = (MediaQuery.of(context).size.height - 500) / 3.0;
        answerPadding = 30.0;
      } else {
        count = 4;
        pointsPerQuestion = 50;
        answerHeight = (MediaQuery.of(context).size.height - 450) / 4.0;
        answerPadding = 15.0;
      }


    });
  }

  navigate(int time, BuildContext ctx) async {
    t = Timer(Duration(seconds: time), () {

    });
  }

  completeRound() async {
    timeController.timer.cancel();
    if (streakLength > longestStreak) {
      longestStreak = streakLength;
    }

    Navigator.pushAndRemoveUntil(
      context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => RoundCompleted(
            timedOrContinous: Keys.timed,
            difficulty: widget.difficulty,
            earnedXP: regularPoints.toInt(),
            streakXP: streakPoints.toInt(),
            streakLength: longestStreak.toInt(),
            remainingLives: remainingLives - 1,
          ),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 100),
        ),
            (_) => false);
  }

  @override
  void dispose() {
    timeController.removeListener(timerListener);
    timeController.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null || _currentQuestion!.id == "" || questionsList.length == 0)
      return Scaffold(
        backgroundColor: Color.fromRGBO(8, 8, 24, 1.0),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    else
      return WillPopScope(
        onWillPop: () => _pop(context),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
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
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            alignment: Alignment.center,
                            height: 185.0,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                            BouncingWidget(
                            duration: Duration(milliseconds: 30),
                              scaleFactor: 1.5,
                              onPressed: () {  tappedBomb(); },
                                      child: Container(
                                        height: 90.0,
                                        width: 90.0,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(37, 38, 65, 0.7),
                                          border: Border.all(
                                              color: Colors.black26, width: 3),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(0,
                                                  0), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 5,
                                            bottom: 5),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15, top: 5),
                                              child: Image.asset(
                                                  'assets/bomb_icon.png'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5, top: 7.5),
                                              child: Text(
                                                remainingBombs == null
                                                    ? ""
                                                    : "$remainingBombs Left",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.03,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            BouncingWidget(
                                duration: Duration(milliseconds: 30),
                                scaleFactor: 1.5,
                                onPressed: () {  tappedClock(); },
                                      child: Container(
                                        height: 90.0,
                                        width: 90.0,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(37, 38, 65, 0.7),
                                          border: Border.all(
                                              color: Colors.black26, width: 3),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(0,
                                                  0), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 5,
                                            bottom: 5),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15, top: 5),
                                              child: Image.asset(
                                                  'assets/clock_icon.png'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5, top: 7.5),
                                              child: Text(
                                                remainingClocks == null
                                                    ? ""
                                                    : "$remainingClocks Left",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.03,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                BouncingWidget(
                    duration: Duration(milliseconds: 30),
                    scaleFactor: 1.5,
                    onPressed: () {  tappedHourglass(); },
                                      child: Container(
                                        height: 90.0,
                                        width: 90.0,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(37, 38, 65, 0.7),
                                          border: Border.all(
                                              color: Colors.black26, width: 3),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(0,
                                                  0), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 5,
                                            bottom: 5),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 21, right: 21, top: 5),
                                              child: Image.asset(
                                                  'assets/hourglass_icon.png'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5, top: 7.5),
                                              child: Text(
                                                remainingHourglasses == null
                                                    ? ""
                                                    : "$remainingHourglasses Left",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.03,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlineGradientButton(
                                      child: SizedBox(
                                        width: 52,
                                        height: 52,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('${timeController.timevalue}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25)),
                                          ],
                                        ),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).secondaryHeaderColor
                                        ],
                                        begin: Alignment(-1, -1),
                                        end: Alignment(2, 2),
                                      ),
                                      strokeWidth: 4,
                                      padding: EdgeInsets.zero,
                                      radius: Radius.circular(26),
                                    ),
                                    SizedBox(width: 5),
                                    StreakBar(key: _streakBarKey, streakCount: streakLength)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 25, bottom: 0, left: 20, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.favorite),
                                    color: Colors.red,
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Text(
                                      remainingLives == null
                                          ? ''
                                          : '${user.lives}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 10, right: 30),
                                        child: Countup(
                                          begin: lastPoints,
                                          end: points,
                                          duration: Duration(milliseconds: 250),
                                          separator: ',',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              _currentQuestion!.synonymOrAntonym,
                              style: TextStyle(
                                color: _currentQuestion!.synonymOrAntonym ==
                                        "synonym"
                                    ? Theme.of(context).secondaryHeaderColor
                                    : Theme.of(context).primaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.075,
                              ),
                            ),
                            Text(
                              _currentQuestion!.word,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _currentQuestion == null
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : ListView.builder(
                                            itemCount: count >= answers.length ? answers.length : count,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                height: answerHeight,
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 30, right: 30, bottom: 30),
                                                child: _tappableAnimatedContainer(
                                                      answers[index]
                                                          .toUpperCase(),
                                                      index % 2 == 0,
                                                      _currentQuestion!
                                                              .synonymOrAntonym ==
                                                          "synonym", () {
                                                    _animateFlag = false;
                                                    answerQuestion(index);

                                                  }),

                                              );
                                            }),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 185),
                          ],
                        ),
                        IgnorePointer(
                          child: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(color: Colors.black, width: 20),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                            ),
                          ),
                        ),
                        IgnorePointer(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                            ),
                          ),
                        ),
                        IgnorePointer(
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    width: 2.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _tappableAnimatedContainer(
      String txt, bool left, bool synonym, Function()? onTap) {
    return BouncingWidget(
        duration: Duration(milliseconds: 30),
        scaleFactor: 1.5,
        onPressed: onTap!,
      child: AnimatedContainer(
        duration: Keys.playAnimDuration,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(37, 38, 65, 0.7),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
          border: Border.all(
              color: synonym
                  ? Theme.of(context).secondaryHeaderColor
                  : Theme.of(context).primaryColor,
              width: 1),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        width: _animateFlag ? MediaQuery.of(context).size.width * 0.8 : 0,
        child: Center(
          child: Opacity(
            opacity: _animateFlag ? 1 : 0,
            child: Text(
              txt.toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }

  answerQuestion(int index) async {
    loading = true;
    _animateFlag = false;
    print(index);

    FirebaseFirestore.instance
        .collection("users")
        .doc(Constants.useruid)
        .collection(_currentQuestion!.synonymOrAntonym)
        .doc(_currentQuestion!.id)
        .set({
      'question': _currentQuestion!.word,
      'answergiven': answers[index],
      'correctanswer': _currentQuestion!.answers[_currentQuestion!.correctAnswer],
      'qid': _currentQuestion!.id
    });

    if (answers[index] ==
        _currentQuestion!.answers[_currentQuestion!.correctAnswer]) {

      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/Sound_Correct.wav"),
        autoStart: true,
        showNotification: false,
      );


      lastPoints = points;
      if (_streakBarKey.currentState != null) {
        _streakBarKey.currentState!.addCorrectAnswer();
      }

      int numPoints = pointsPerQuestion;
      if (streakLength >= 3) {
        numPoints = numPoints * 2;
        streakPoints += numPoints;
      } else {
        regularPoints += numPoints;
      }



      setState(() {
        streakLength += 1;
        points += numPoints;
        answer = "correct";
        HapticFeedback.mediumImpact();
      });
      await Future.delayed(Duration(milliseconds: 700), () {
        setState(() {
          print("Setting state");
          answer = "";
        });
      });
    } else {
      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/Sound_Wrong.wav"),
        autoStart: true,
        showNotification: false,
      );

      if (streakLength > longestStreak) {
        longestStreak = streakLength;
      }

      if (_streakBarKey.currentState != null) {
        _streakBarKey.currentState!.addWrongAnswer();
      }

      setState(() {
        streakLength = 0;
        answer = "wrong";
        HapticFeedback.lightImpact();
      });
    }
    if (widget.gameType == Keys.puzzle && !widget.continuous) {
      if (answers[index] ==
          _currentQuestion!.answers[_currentQuestion!.correctAnswer]) {
        _currentTime += 10;
      } else {
        _currentTime = 10;
      }
    }

    await Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        answer = "";
      });

      _animateFlag = true;
      // setState(() {});
    });

    await _pickQuestion();
  }

  fetchStoredUser() async {
    var prefResult = (await SharedPreferences.getInstance()).get(Keys.user);

    user = LocalUser.fromMap(json.decode(prefResult as String));
    setState(() {
      remainingLives = user.lives == null ? 3 : user.lives;
      remainingBombs = user.bombs == null ? 5 : user.bombs;
      remainingClocks = user.clocks == null ? 5 : user.clocks;
      remainingHourglasses = user.hourglasses == null ? 5 : user.hourglasses;
    });
  }

  fetchUser() async {
    debugPrint("Fetching user");
    var u =  await AuthHelper().getRemoteUser(context);
    user = u!;
    debugPrint('Got ${user.email}');
    setState(() {
      debugPrint('Lives ${user.lives}');
      remainingLives = user.lives = user.lives;
      remainingBombs = user.bombs = user.bombs;
      remainingClocks = user.clocks = user.clocks;
      remainingHourglasses = user.hourglasses = user.hourglasses;
    });
  }

  _pickQuestion() async {
    if (widget.wordType != "")
      index++;
    else {
      if (index == questionsList.length - 1) index = 0;
      index++;
    }
    if (index == questionsList.length) {

     completeRound();
    }
    var ques = questionsList[index];
    print(ques.answers);
    if (widget.wordType != Keys.allwords) {
      if (ques.synonymOrAntonym == widget.wordType &&
          !usedquestionslist.contains(ques.id)) {
        _currentQuestion = ques;
        hasQuestion = true;
        prepareAnswers();
        usedquestionslist.add(ques.id);
      } else
        _pickQuestion();
    } else {
      if (usedquestionslist.length == questionsList.length) {
      completeRound();
      } else {
        if (!usedquestionslist.contains(ques.id)) {
          if (ques.synonymOrAntonym == mix.toString()) {
            _currentQuestion = ques;
            hasQuestion = true;
            prepareAnswers();
            usedquestionslist.add(ques.id);
            if (mix == 'synonym')
              setState(() {
                mix = 'antonym';
              });
            else
              setState(() {
                mix = 'synonym';
              });
          } else {
            _pickQuestion();
          }

          loading = false;
        }
      }
    }

    _animateFlag = true;
    setState(() {});
  }

  prepareAnswers() {
    if (_currentQuestion!.answers.length >= count) {
      answers.clear();
      var correctAnswer =
          _currentQuestion!.answers[_currentQuestion!.correctAnswer];
      answers.add(correctAnswer);

      for (var i = 0; i < _currentQuestion!.answers.length; i++) {
        var element = _currentQuestion!.answers[i];
        if (answers.length < count) {
          if (element != correctAnswer) {

            answers.add(element);
          }
        }
      }
    }
  }

  pause() async {
    print("Pausing");
    _pausedTime = _currentTime;
    timeController.timer.cancel();

    var reset = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PauseScreen(
                _currentQuestion!.synonymOrAntonym == Keys.synonym
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColorDark)));
    if (_pausedTime != null) {
      _currentTime = _pausedTime;
      _pausedTime = 0;
      //_initTimer();
    }
    if (reset == true) {
      t.cancel();
      timeController.timer.cancel();
      timeController.setTimer(_currentTime);
      print("Pause");
      //navigate(_currentTime, context);
      setState(() {
        _currentTime = 60;
      });
    }
  }

  Future<bool> _pop(BuildContext ctx) async {
    print("POPPING CALLED");
    if (_currentTime != null) {
      _pausedTime = _currentTime;
      // Get.off(ResultScreen(
      //   timedOrContinous: Keys.timed,
      //   difficulty: widget.difficulty,
      //   rightAns: _correctAnswers,
      //   wrongAns: _wrongAnswers,
      // ));
      // Navigator.pushReplacement(
      //    ctx,
      //     MaterialPageRoute(
      //         builder: (_) =>
      //             ResultScreen(
      //               timedOrContinous: Keys.timed,
      //               difficulty: widget.difficulty,
      //               rightAns: _correctAnswers,
      //               wrongAns: _wrongAnswers,
      //             )));
      // tim.timevalue.cancel();
      // tim.timevalue = null;
    }
    var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        title: Text('Warning!'),
        content: Text(
            'Are you sure you want to go back?\nAll your game progress will be lost.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(closeOverlays: true),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (!result) {
      _currentTime = _pausedTime;
      _pausedTime = 0;
      // _initTimer();
      return false;
    } else {
      Navigator.pop(context);
      return true;
    }
  }

  readQuestions() async {
    FirebaseFirestore.instance.collection("questions").get().then((value) {
      value.docs.forEach((element) {
        if (widget.wordType == element.data()['synonymOrAntonym']) {
          questionsList.add(Question.fromMap(element.data()));
        }
        if (widget.wordType == Keys.allwords)
          questionsList.add(Question.fromMap(element.data()));
      });

      questionsList.shuffle();
      debugPrint("Pick question 2");
      _pickQuestion();
      print(questionsList);
    });
    //   .forEach((result) {
    //     print(result.data());
    // });
  }

  // Pause for 5 seconds
  tappedHourglass() {
    if (user.hourglasses == 0) {
      HapticFeedback.heavyImpact();
      return;
    }

    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/pause.wav"),
      autoStart: true,
      showNotification: false,
    );

    HapticFeedback.lightImpact();
    timeController.pauseValue += 5;
    user.hourglasses -= 1;
    setState(() {
      remainingHourglasses = user.hourglasses;
    });

    FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(user.uid)
        .update({'hourglasses': user.hourglasses});

  }

  // Extra 5 seconds
  tappedClock() {
    if (user.clocks == 0) {
      HapticFeedback.heavyImpact();
      return;
    }

    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/clock.wav"),
      autoStart: true,
      showNotification: false,
    );

    HapticFeedback.lightImpact();

    timeController.timevalue += 5;
    user.clocks -= 1;
    setState(() {
      remainingClocks = user.clocks;
    });

    FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(user.uid)
        .update({'clocks': user.clocks});
  }

  tappedBomb() {
    if (user.bombs == 0) {
      HapticFeedback.heavyImpact();
      return;
    }

    if (count == 1) {
      HapticFeedback.heavyImpact();
      return;
    }

    print("Tapped bomb");
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/bomb.wav"),
      autoStart: true,
      showNotification: false,
    );

    HapticFeedback.lightImpact();

    user.bombs -= 1;
    debugPrint("COUNT IS $count");
    for(var answer in answers) {

    }

    count = count - 1;

    setState(() {
      remainingBombs = user.bombs;

    });

    FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(user.uid)
        .update({'bombs': user.bombs});

  }

  Future<void> readUserData() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((querySnapshot) {
        print(querySnapshot.data());
        //userName = querySnapshot.data()['userName'];
        //email = querySnapshot.data()['email'];
        setState(() {});
      });
    }
  }
}
