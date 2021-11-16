import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:synonym_app/Controllers/timeController.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/res/constants.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/single_player/pause_screen.dart';
import 'package:synonym_app/ui/single_player/round_completed.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:synonym_app/ui/shared/grid.dart';
import 'package:flutter/services.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class SinglePlayerGamePage extends StatefulWidget {
  final String gameType;
  final String difficulty;
  final bool continuous;
  final String wordType;

  SinglePlayerGamePage({
    @required this.gameType,
    @required this.wordType,
    this.difficulty = Keys.medium,
    this.continuous = false,
  });

  @override
  _SinglePlayerGamePageState createState() => _SinglePlayerGamePageState();
}

class _SinglePlayerGamePageState extends State<SinglePlayerGamePage>
    with TickerProviderStateMixin<SinglePlayerGamePage> {
  bool loading = false;

  Question _currentQuestion;
  List<String> usedquestionslist = [];
  int _correctAnswers = 0, _wrongAnswers = 0;
  String answer = "";
  int _currentTime, _pausedTime;
  Timer t;
  String mix = 'synonym';
  bool _animateFlag;

  // Timer tim.timevalue;
  List<Widget> output = [];
  Key x = UniqueKey();
  double width;
  int count;
  List<Question> questionsList = [];
  int index = -1;

  int a;
  var tim, tim2;
  TimerController controller = Get.put(TimerController());

  @override
  void initState() {
    super.initState();

    _animateFlag = false;
    print("Single player init called");

    readquestions();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.difficulty == Keys.easy) {
        count = 2;
        width = MediaQuery.of(context).size.width / 1.33;
      } else if (widget.difficulty == Keys.medium) {
        count = 3;
        width = MediaQuery.of(context).size.width / 1.3;
      } else {
        count = 4;
        width = MediaQuery.of(context).size.width / 1.5;
      }
      if (widget.continuous)
        _currentTime = null;
      else {
        if (widget.gameType == Keys.puzzle)
          _currentTime = 10;
        else
          _currentTime = 60;
        if (_currentTime != null) {
          print("Intro Pause");
          navigate(_currentTime, context);
          controller.setTimer(_currentTime);
        }
      }
    });
  }

  navigate(int time, BuildContext ctx) async {
    // t = Timer(Duration(seconds: time), () {
    //   Navigator.of(ctx).pushAndRemoveUntil(
    //       MaterialPageRoute(
    //           builder: (_) => RoundCompleted(
    //                 timedOrContinous: Keys.timed,
    //                 difficulty: widget.difficulty,
    //                 rightAns: _correctAnswers,
    //                 wrongAns: _wrongAnswers,
    //               )),
    //       (route) => false);
    // });
  }

  @override
  void dispose() {
    controller.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null)
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
                            height: 150.0,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(height: 90.0, width: 90.0,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(37, 38, 65, 0.7),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 5)
                                        ],
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 1),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 15)
                                    ),
                                    Container(height: 90.0, width: 90.0,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(37, 38, 65, 0.7),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 5)
                                          ],
                                          border: Border.all(
                                              color: Colors.white,
                                              width: 1),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 15)
                                    ),
                                    Container(height: 90.0, width: 90.0,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(37, 38, 65, 0.7),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 5)
                                          ],
                                          border: Border.all(
                                              color: Colors.white,
                                              width: 1),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 15)
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(height: 50.0, width: 50.0, color: Colors.yellow),
                                    Container(height: 50.0, width: 50.0, color: Colors.cyan),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        answer == "correct"
                            ? TweenAnimationBuilder(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(30, 30, 30, 40),
                                    child: Container(
                                      height: 50.0,
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        "+ 50 POINTS",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.075,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                curve: Curves.slowMiddle,
                                tween: Tween<double>(begin: 0, end: 1),
                                duration: Duration(seconds: 1),
                                builder: (BuildContext context, double _val,
                                    Widget child) {
                                  return Padding(
                                      padding: EdgeInsets.only(left: _val),
                                      child: child);
                                },
                              )
                            : answer == "wrong"
                                ? TweenAnimationBuilder(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 30, 30, 40),
                                        child: Text(
                                          "WRONG",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.075,
                                          ),
                                        ),
                                      ),
                                    ),
                                    curve: Curves.slowMiddle,
                                    tween: Tween<double>(begin: 0, end: 1),
                                    duration: Duration(seconds: 1),
                                    builder: (BuildContext context, double _val,
                                        Widget child) {
                                      return Padding(
                                          padding: EdgeInsets.only(left: _val),
                                          child: child);
                                    },
                                  )
                                : Container(),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.favorite),
                                      color: Colors.red,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          '3',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            MediaQuery.of(context).size.width * 0.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ),
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 10, right: 30),
                                        child: Text(
                                          '0000',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            MediaQuery.of(context).size.width * 0.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ),
                                    ),
                                  ],
                                ),
                            ),

                            SizedBox(height: 30.0),
                            Text(
                              _currentQuestion.synonymOrAntonym,
                              style: TextStyle(
                                color: _currentQuestion
                                    .synonymOrAntonym ==
                                    "synonym"
                                    ? Theme.of(context)
                                    .accentColor
                                    : Theme.of(context)
                                    .primaryColor,
                                fontSize: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.075,
                              ),
                            ),
                            Text(
                              _currentQuestion.word,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size
                                                        .width *
                                    0.15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            _currentTime == null
                                                ? Container()
                                                : Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Obx(
                                                      () => Text(
                                                        ':${controller.timevalue.value}',
                                                        style: TextStyle(
                                                            fontSize: 25),
                                                      ),
                                                    ),
                                                  ),


                            Expanded(
                                child: _currentQuestion == null
                                    ? Center(child: CircularProgressIndicator())
                                    : ListView.builder(
                                        itemCount: count,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 30),


                                            child: Padding(
                                              padding: EdgeInsets.all(15),
                                              child: _tappableAnimatedContainer(
                                                    _currentQuestion
                                                        .answers[index]
                                                        .toUpperCase(),
                                                    index % 2 == 0,
                                                    _currentQuestion
                                                            .synonymOrAntonym ==
                                                        "synonym", () {
                                                  _animateFlag = false;
                                                  answerQuestion(index);
                                                  HapticFeedback.lightImpact();
                                                }),

                                            ),
                                          );
                                        })),
                            SizedBox(height: 10),
                          ],
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
      String txt, bool left, bool synonym, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Keys.playAnimDuration,
        height: 75,
        decoration: BoxDecoration(

              color: Color.fromRGBO(37, 38, 65, 0.7),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5)
              ],
              border: Border.all(
                  color: synonym
                      ? Theme.of(context).secondaryHeaderColor
                      : Theme.of(context).primaryColor,
                  width: 1),
              borderRadius:
              BorderRadius.all(Radius.circular(30)),
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
        .collection(_currentQuestion.synonymOrAntonym)
        .doc(_currentQuestion.id)
        .set({
      'question': _currentQuestion.word,
      'answergiven': _currentQuestion.answers[index],
      'correctanswer': _currentQuestion.answers[_currentQuestion.correctAnswer],
      'qid': _currentQuestion.id
    });

    if (_currentQuestion.answers[index] ==
        _currentQuestion.answers[_currentQuestion.correctAnswer]) {
      _correctAnswers++;

      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/Sound_Correct.wav"),
        autoStart: true,
        showNotification: false,
      );

      setState(() {
        answer = "correct";
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

      _wrongAnswers++;
      setState(() {
        answer = "wrong";
      });
    }
    if (widget.gameType == Keys.puzzle && !widget.continuous) {
      if (_currentQuestion.answers[index] ==
          _currentQuestion.answers[_currentQuestion.correctAnswer]) {
        _currentTime += 10;
      } else {
        _currentTime = 10;
      }
    }
    if (widget.continuous && _wrongAnswers == 1) {
      print("HERE 1");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => RoundCompleted(
                    timedOrContinous: Keys.timed,
                    difficulty: widget.difficulty,
                    rightAns: _correctAnswers,
                    wrongAns: _wrongAnswers,
                  )));
      return;
    }
    await Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        print("Set state 2");
        answer = "";
      });

      _animateFlag = true;
      // setState(() {});
    });
    await _pickQuestion();
  }

  _pickQuestion() async {
    if (widget.wordType != null)
      index++;
    else {
      if (index == questionsList.length - 1) index = 0;
      index++;
    }
    if (index == questionsList.length) {
      print("HERE 3");
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => RoundCompleted(
      //               timedOrContinous: Keys.timed,
      //               difficulty: widget.difficulty,
      //               rightAns: _correctAnswers,
      //               wrongAns: _wrongAnswers,
      //             )));
    }
    var ques = questionsList[index];
    print("QUESTION");
    print(ques.answers);
    if (widget.wordType != null) {
      if (ques.synonymOrAntonym == widget.wordType &&
          !usedquestionslist.contains(ques.id)) {
        _currentQuestion = ques;
        usedquestionslist.add(ques.id);
      } else
        _pickQuestion();
    } else {
      if (usedquestionslist.length == questionsList.length) {
        print("HERE 5");
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => RoundCompleted(
        //               timedOrContinous: Keys.timed,
        //               difficulty: widget.difficulty,
        //               rightAns: _correctAnswers,
        //               wrongAns: _wrongAnswers,
        //             )));
      } else {
        if (!usedquestionslist.contains(ques.id)) {
          if (ques.synonymOrAntonym == mix.toString()) {
            _currentQuestion = ques;
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

  _pause() async {
    print("Pausing");
    if (_currentTime != null) {
      _pausedTime = _currentTime;
      controller.timer.cancel();
    }
    var reset = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PauseScreen(
                _currentQuestion.synonymOrAntonym == Keys.synonym
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColorDark)));
    if (_pausedTime != null) {
      _currentTime = _pausedTime;
      _pausedTime = null;
      // _initTimer();
    }
    if (reset == true) {
      t.cancel();
      controller.timer.cancel();
      controller.setTimer(_currentTime);
      print("Pause");
      navigate(_currentTime, context);
      setState(() {
        _correctAnswers = 0;
        _wrongAnswers = 0;
        _currentTime = 60;
      });
    }
  }

  Future<bool> _pop(BuildContext ctx) async {
    print("POPPING CLALED");
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
          FlatButton(
            onPressed: () => Get.back(closeOverlays: true),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (!result) {
      _currentTime = _pausedTime;
      _pausedTime = null;
      // _initTimer();
      return false;
    } else {
      Navigator.pop(context);
      return true;
    }
  }

  void readquestions() {
    FirebaseFirestore.instance.collection("questions").get().then((value) {
      value.docs.forEach((element) {
        if (widget.wordType == element.data()['synonymOrAntonym']) {
          questionsList.add(Question.fromMap(element.data()));
        }
        if (widget.wordType == null)
          questionsList.add(Question.fromMap(element.data()));
      });

      questionsList.shuffle();
      _pickQuestion();
      print(questionsList);
    });
    //   .forEach((result) {
    //     print(result.data());
    // });
  }
}

class _MarksBox extends StatelessWidget {
  final String marks;

  _MarksBox(this.marks);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        marks,
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.04,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
