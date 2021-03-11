import 'dart:async';
import 'dart:math';
import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/Controllers/timeController.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/res/constants.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/single_player/pause_screen.dart';
import 'package:synonym_app/ui/single_player/result_screen.dart';
import 'package:synonym_app/ui/single_player/timercontroller.dart';

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
    with SingleTickerProviderStateMixin<SinglePlayerGamePage> {
  bool loading = false;
  Question _currentQuestion;
  List<String> usedquestionslist = [];
  int _correctAnswers = 0, _wrongAnswers = 0;
  String answer = "";
  int _currentTime, _pausedTime;
  Timer t;
  String mix = 'synonym';

  // Timer tim.timevalue;
  List<Widget> output = [];
  Key x = UniqueKey();
  double width;
  int count;
  List<Question> questionsList = [];
  int index = -1;
  Animation animation;
  AnimationController animationController;
  int a;
  var tim, tim2;
  TimerController controller = Get.put(TimerController());

  @override
  void initState() {
    super.initState();

    print("Single player init called");
    animationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.forward();
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
          navigate(_currentTime, context);
          controller.setTimer(_currentTime);
        }
      }
    });
  }

  navigate(int time, BuildContext ctx) async {
    t = Timer(Duration(seconds: time), () {
      Navigator.of(ctx).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => ResultScreen(
                    timedOrContinous: Keys.timed,
                    difficulty: widget.difficulty,
                    rightAns: _correctAnswers,
                    wrongAns: _wrongAnswers,
                  )),
          (route) => false);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    controller.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null)
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    else
      return WillPopScope(
        onWillPop: () => _pop(context),
        child: Scaffold(
          backgroundColor: _currentQuestion.synonymOrAntonym == Keys.synonym
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColorDark,
          body: Column(
            children: <Widget>[
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      onPressed: () => _pop(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: <Widget>[
                          Text(
                            _currentQuestion.word,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _currentQuestion.synonymOrAntonym,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.pause),
                      color: Colors.white,
                      onPressed: _pause,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Column(
                        children: <Widget>[
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: _MarksBox(
                                  'Right: ${_correctAnswers.toString()}',
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: _MarksBox(
                                  'Wrong: ${_wrongAnswers.toString()}',
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: _currentQuestion == null
                                ? Center(child: CircularProgressIndicator())
                                : ListView.builder(
                                    itemCount: count,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          // width: MediaQuery.of(context).size.width,
                                          height: 113,
                                          child: Padding(
                                            padding: EdgeInsets.all(2),
                                            child: Dismissible(
                                              key: Key(DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString()),
                                              direction: index % 2 == 0
                                                  ? DismissDirection.startToEnd
                                                  : DismissDirection.endToStart,
                                              onDismissed: (dir) async {
                                                onDismissed(index);
                                              },
                                              child: Stack(
                                                children: <Widget>[
                                                  Align(
                                                    alignment: index % 2 == 0
                                                        ? Alignment.centerLeft
                                                        : Alignment.centerRight,
                                                    child: Image.asset(
                                                      _currentQuestion
                                                                  .synonymOrAntonym ==
                                                              Keys.synonym
                                                          ? index % 2 == 0
                                                              ? 'assets/arrow_left_blue.png'
                                                              : 'assets/arrow_right_blue.png'
                                                          : index % 2 == 0
                                                              ? 'assets/arrow_left_red.png'
                                                              : 'assets/arrow_right_red.png',
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: index % 2 == 0
                                                        ? Alignment(-0.6, 0)
                                                        : Alignment(0.6, 0),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              30),
                                                      child: Text(
                                                        _currentQuestion
                                                            .answers[index]
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
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
                                          ));
                                    }),
                          ),
                          _currentTime == null
                              ? Container()
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            _currentQuestion.synonymOrAntonym ==
                                                    Keys.synonym
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .primaryColorDark,
                                        width: 2),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Obx(
                                    () => Text(
                                      ':${controller.timevalue.value}',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 10),
                        ],
                      ),

                      ///----------------------------------------------------------------------
                      /*     Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 4),
                        child: FadeTransition(
                          opacity:_fadeInFadeOut,
                          // .drive(CurveTween(curve: Curves.slowMiddle)),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                    AssetImage("assets/right.png"))),
                          ),
                        ),
                      ),*/

                      answer == "correct"
                          ? TweenAnimationBuilder(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height / 4),
                                child: FadeTransition(
                                  opacity: animationController
                                      .drive(CurveTween(curve: Curves.easeOut)),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                AssetImage("assets/right.png")),
                                      )),
                                ),
                              ),
                              curve: Curves.slowMiddle,
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: Duration(seconds: 1),
                              builder: (BuildContext context, double _val,
                                  Widget child) {
                                return Opacity(opacity: _val, child: child);
                              },
                            )
                          : answer == "wrong"
                              ? TweenAnimationBuilder(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                4),
                                    child: FadeTransition(
                                      opacity: animationController.drive(
                                          CurveTween(curve: Curves.easeOut)),
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/wrong.png")),
                                          )),
                                    ),
                                  ),
                                  curve: Curves.slowMiddle,
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: Duration(seconds: 1),
                                  builder: (BuildContext context, double _val,
                                      Widget child) {
                                    return Opacity(opacity: _val, child: child);
                                  },
                                )

                              /* Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          4),
                                  child: FadeTransition(
                                    opacity: animationController.drive(
                                        CurveTween(curve: Curves.easeOut)),
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/wrong.png")),
                                        )),
                                  ),
                                )*/
                              : Container()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  onDismissed(int index) async {
    loading = true;

    Firestore.instance
        .collection("users")
        .document(Constants.useruid)
        .collection(_currentQuestion.synonymOrAntonym)
        .document(_currentQuestion.id)
        .setData({
      'question': _currentQuestion.word,
      'answergiven': _currentQuestion.answers[index],
      'correctanswer': _currentQuestion.answers[_currentQuestion.correctAnswer],
      'qid': _currentQuestion.id
    });

    if (_currentQuestion.answers[index] ==
        _currentQuestion.answers[_currentQuestion.correctAnswer]) {
      _correctAnswers++;
      setState(() {
        answer = "correct";
      });
      await Future.delayed(Duration(milliseconds: 700), () {
        setState(() {
          answer = "";
        });
      });
    } else {
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
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ResultScreen(
                    timedOrContinous: Keys.timed,
                    difficulty: widget.difficulty,
                    rightAns: _correctAnswers,
                    wrongAns: _wrongAnswers,
                  )));
      return;
    }
    await Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        answer = "";
      });
      // setState(() {});
    });
    await _pickQuestion();
  }

  List<Widget> _answersUI() {
    double width;
    int count;
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
    output = List();
    for (int i = 0; i < count; i++) {
      print("iiiiiiiiiiiiiiiiiiiii");
      print(i);
      print("$x");
      var wid = Expanded(
        child: Dismissible(
          // key:Key(DateTime.now().millisecondsSinceEpoch.toString()),
          key: Key('${_currentQuestion.id}'),
          // key:Key('${x.toString()}'),
          //  key: UniqueKey()  ,
          direction: i % 2 == 0
              ? DismissDirection.startToEnd
              : DismissDirection.endToStart,
          onDismissed: (dir) async {
            // output.removeAt(i);
            // setState(() {
            loading = true;
            // });
            Firestore.instance
                .collection("users")
                .document(Constants.useruid)
                .collection(_currentQuestion.synonymOrAntonym)
                .document(_currentQuestion.id)
                .setData({
              'question': _currentQuestion.word,
              'answergiven': _currentQuestion.answers[i],
              'correctanswer':
                  _currentQuestion.answers[_currentQuestion.correctAnswer],
              'qid': _currentQuestion.id
            });
            print(_currentQuestion.answers[_currentQuestion.correctAnswer]);
            if (_currentQuestion.answers[i] ==
                _currentQuestion.answers[_currentQuestion.correctAnswer]) {
              _correctAnswers++;
              setState(() {
                answer = "correct";
              });
              await Future.delayed(Duration(milliseconds: 400), () {
                setState(() {
                  answer = "";
                });
              });
            } else {
              _wrongAnswers++;
              setState(() {
                answer = "wrong";
              });
            }
            if (widget.gameType == Keys.puzzle && !widget.continuous) {
              if (_currentQuestion.answers[i] ==
                  _currentQuestion.answers[_currentQuestion.correctAnswer]) {
                _currentTime += 10;
              } else {
                _currentTime = 10;
              }
            }
            if (widget.continuous && _wrongAnswers == 1) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ResultScreen(
                            timedOrContinous: Keys.timed,
                            difficulty: widget.difficulty,
                            rightAns: _correctAnswers,
                            wrongAns: _wrongAnswers,
                          )));
              return;
            }
            await Future.delayed(Duration(milliseconds: 400), () {
              setState(() {
                answer = "";
              });
              // setState(() {});
            });
            await _pickQuestion();
          },
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
      print(".............................................");
      output.add(wid);
    }
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    return output;
  }

  _pickQuestion() async {
    if (widget.wordType != null)
      index++;
    else {
      if (index == questionsList.length - 1) index = 0;
      index++;
    }
    if (index == questionsList.length) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ResultScreen(
                    timedOrContinous: Keys.timed,
                    difficulty: widget.difficulty,
                    rightAns: _correctAnswers,
                    wrongAns: _wrongAnswers,
                  )));
    }
    var ques = questionsList[index];
    if (widget.wordType != null) {
      if (ques.synonymOrAntonym == widget.wordType &&
          !usedquestionslist.contains(ques.id)) {
        _currentQuestion = ques;
        usedquestionslist.add(ques.id);
      } else
        _pickQuestion();
    } else {
      if (usedquestionslist.length == questionsList.length) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => ResultScreen(
                      timedOrContinous: Keys.timed,
                      difficulty: widget.difficulty,
                      rightAns: _correctAnswers,
                      wrongAns: _wrongAnswers,
                    )));
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
    setState(() {});
  }

  _pause() async {
    if (_currentTime != null) {
      _pausedTime = _currentTime;
      // tim.timevalue?.cancel();
      // tim.timevalue = null;
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
      navigate(_currentTime, context);
      setState(() {
        _correctAnswers = 0;
        _wrongAnswers = 0;
        _currentTime = 60;
      });
    }
  }

  Future<bool> _pop(BuildContext ctx) async {
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
    Firestore.instance.collection("questions").getDocuments().then((value) {
      value.documents.forEach((element) {
        if (widget.wordType == element.data['synonymOrAntonym']) {
          questionsList.add(Question.fromMap(element.data));
        }
        if (widget.wordType == null)
          questionsList.add(Question.fromMap(element.data));
      });
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
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        marks,
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
