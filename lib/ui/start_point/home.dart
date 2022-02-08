import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/auth/login_start.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:synonym_app/ui/single_player/pregame/game_difficulty_chooser.dart';
import 'package:synonym_app/ui/shared/grid.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/ui/start_point/walk_through_page.dart';
import 'package:synonym_app/ui/profile/help_page.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synonym_app/ui/leaderboard/leaderboard.dart';
import 'package:synonym_app/ui/start_point/home_bottom_card.dart';
import 'package:synonym_app/ui/shared/animated_logo2.dart';
import 'package:synonym_app/ui/single_player/timercontroller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:synonym_app/ui/store/store.dart';
import 'package:synonym_app/ui/single_player/game_complete/progress_screen.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synonym_app/ui/shared/pulsing_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synonym_app/ui/single_player/components/streak_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _animateFlag = false;
  var loggedIn = false;
  var remainingLives = 0;
  TimerController countdownNextHeartController = TimerController();
  int currentHeartTime = 0;
  var canClaimHeart = false;
  var timeTillNextHeart = 0;
  var hasClaimedDailyReward = false;
  // Ads
  late RewardedAd _rewardedAd;

  @override
  void initState() {
    super.initState();
    _getUser();
    currentHeartTime = 600;
    checkHearts();
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
        if (currentHeartTime == 0) {
          setState(() {
              canClaimHeart = true;
          });
        }


      });
    });
  }

  _startGame() {
    Provider.of<QuestionProvider>(context, listen: false).reset();

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => GameDifficultyChooser(
          gameType: Keys.timed,
          continuous: false,
        ),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 100),
      ),
    );
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

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
                        Container(

                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Align(
                            alignment: Alignment.center,
                            child: new AnimatedLogo2(),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(height: 30),
                            (remainingLives == 0)
                                ? BouncingWidget(
                                    duration: Duration(milliseconds: 30),
                                    scaleFactor: 1.5,
                                    onPressed: () {},
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(37, 38, 65, 0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(60)),
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 30),
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 15.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 25),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "No lives remaining",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : PulsingWidget(
                              child:
                            BouncingWidget(
                                    duration: Duration(milliseconds: 30),
                                    scaleFactor: 1.5,
                                    onPressed: () {
                                      if (loggedIn) {
                                        _startGame();
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    WalkThroughPage()));
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(37, 38, 65, 0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(60)),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                            width: 1),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 30),
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                          ],
                        ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BouncingWidget(
                      duration: Duration(milliseconds: 30),
                      scaleFactor: 1.5,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => Store(),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: Duration(milliseconds: 100),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 80.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(37, 38, 65, 0.7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Icon(
                                Icons.store,
                                color: Colors.white,
                                size: 50.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BouncingWidget(
                      duration: Duration(milliseconds: 30),
                      scaleFactor: 1.5,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => Leaderboard(),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: Duration(milliseconds: 100),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 80.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(37, 38, 65, 0.7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Icon(
                                Icons.leaderboard,
                                color: Colors.white,
                                size: 50.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    canClaimHeart ?
                        PulsingWidget(child:
                    BouncingWidget(
                      duration: Duration(milliseconds: 30),
                      scaleFactor: 1.5,
                      onPressed: () {
                        claimHeart();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 80.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(50)),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "$remainingLives",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 7.5),
                          Center(
                            child: Text(
                              "CLAIM",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),)
                    : BouncingWidget(
                      duration: Duration(milliseconds: 30),
                      scaleFactor: 1.5,
                      onPressed: () {
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 80.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(37, 38, 65, 0.7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "$remainingLives",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 7.5),
                          Center(
                            child: Text(
                              "${format(Duration(seconds: currentHeartTime))}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!hasClaimedDailyReward)
              Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
                alignment: Alignment.center,
                height: 150.0,
                width: double.infinity,
                child: Stack(
                  children: [
                    HomeBottomCard(onTap: () { showDailyPrizeAd(); } ),
                    //AllUsers(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<LocalUser> _getUser() async {
    LocalUser user = LocalUser.fromMap((await FirebaseFirestore.instance
            .collection(Keys.user)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get())
        .data()!);

    setState(() {
      debugPrint("REMAINING LIVES IS $remainingLives");
      remainingLives = user.lives;
    });

    return user;
  }

  showDailyPrizeAd() {

    debugPrint("DAILY PRICE TAPPED");
    RewardedAd.load(
        adUnitId: 'ca-app-pub-3042907838603854/8517770808',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          this._rewardedAd = ad;
          ad.show(onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) {
            claimDailyPrizeAd();
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
        },
    ));
  }

  claimDailyPrizeAd() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    var user = await _getUser();

    await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(user.uid)
        .update({'bombs': user.bombs + 1});
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(Keys.lastHeart, timestamp);
    HapticFeedback.mediumImpact();
    setState(() {
      hasClaimedDailyReward = true;
    });

  }

  checkHearts() async {
    var prefResult = (await SharedPreferences.getInstance()).get(Keys.user);
    final prefs = await SharedPreferences.getInstance();
    int timeStamp = prefs.getInt(Keys.lastHeart) ?? 0;
    if (timeStamp == 0) {
      setState(() {
        canClaimHeart = true;
      });
    } else {
      DateTime before = DateTime.fromMillisecondsSinceEpoch(timeStamp);
      DateTime now = DateTime.now();
      Duration timeDifference = now.difference(before);
      int seconds = timeDifference.inSeconds;
      setState(() {
        if (seconds > 14400) {
          canClaimHeart = true;
        } else {
          canClaimHeart = false;
          countdownNextHeartController.setTimer(14400 - seconds);
        }
      });
    }
  }

  claimHeart() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    var user = await _getUser();

    await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(user.uid)
        .update({'lives': user.lives + 1});
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(Keys.lastHeart, timestamp);
    HapticFeedback.mediumImpact();
    setState(() {
      remainingLives = user.lives + 1;
      canClaimHeart = false;
      countdownNextHeartController.setTimer(14400);
    });
  }

}
