import 'package:flutter/material.dart';
import 'package:synonym_app/ui/single_player/components/streak_bar_background.dart';

// 3 correct creates a streak
// During streaking answers are double points
// Wrong answer redoes streak
// Right answer extends streak



class StreakBar extends StatefulWidget {
  const StreakBar ({Key? key}) : super(key: key);

  @override
  StreakBarState createState() => StreakBarState();
}

class StreakBarState extends State<StreakBar>
    with SingleTickerProviderStateMixin {
  double _scale = 0.0;
  late AnimationController _controller;

  addCorrectAnswer() {

  }

  addWrongAnswer() {

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
        EdgeInsets.symmetric(vertical: 15),
        child:
          Stack(
            children: [
              StreakBarBackground(),
            ]
          ),
      ),
    );
  }
}