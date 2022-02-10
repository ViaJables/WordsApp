import 'package:flutter/material.dart';
import 'package:synonym_app/ui/single_player/components/streak_bar_background.dart';
import 'package:animated_fractionally_sized_box/animated_fractionally_sized_box.dart';
import 'package:synonym_app/ui/shared/pulsing_widget.dart';

// 3 correct creates a streak
// During streaking answers are double points
// Wrong answer redoes streak
// Right answer extends streak



class StreakBar extends StatefulWidget {
  final int streakCount;

  const StreakBar ({Key? key,
    required this.streakCount
  }) : super(key: key);

  @override
  StreakBarState createState() => StreakBarState();
}

class StreakBarState extends State<StreakBar>
    with SingleTickerProviderStateMixin {
  double _scale = 0.0;
  late AnimationController _controller;
  var currentStreak = 0;
  var percentage = 0.1;

  addCorrectAnswer() {
    setState(() {
      currentStreak += 1;

      if (currentStreak == 0) {
        percentage = 0.1;
      } else if (currentStreak == 1) {
        percentage = 0.33;
      } else if (currentStreak == 2) {
        percentage = 0.66;
      } else {
        percentage = 1.0;
      }

    });
  }

  addWrongAnswer() {
    setState(() {
      percentage = 0.1;
      currentStreak = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color:
          Color.fromRGBO(37, 38, 65, 0.7),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 5)
          ],
          border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 3),
          borderRadius: BorderRadius.all(
              Radius.circular(25)),
        ),
        padding:
        EdgeInsets.all(5),
        child:
          Stack(
            children: [
              AnimatedFractionallySizedBox(
                duration: Duration(milliseconds: 150),
              widthFactor: percentage,
              heightFactor: 1.0,
              child:
              StreakBarBackground(),
              ),
              Row(
                children: [
                  Expanded(
                    child:
                        currentStreak >= 3 ?
                        Center(
                          child:
                          PulsingWidget(
                            child:
                  Text(
                      "Double XP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                        20.0,
                        fontWeight: FontWeight.w300,

                      ),
                  ),
                          ),
                  ) : Container()
                  ),
                  SizedBox(width: 50.0, height: double.infinity,
                  child:
                      Center(
                        child:
                  Text(
                    "$currentStreak",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                      24.0,
                      fontWeight: FontWeight.w800,

                    ),
                  ),
                      ),
                  )
                ]
              )
            ]
          ),
      ),
    );
  }
}