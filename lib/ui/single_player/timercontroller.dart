import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerController with ChangeNotifier {
  int timevalue = 0;
  int pauseValue = 0;
  late Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  setTimer(int newtime) {
    timevalue = newtime;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(pauseValue == 0) {
        timevalue = timevalue - 1;
      } else {
        pauseValue = pauseValue - 1;
      }


      if (timevalue == 0) {
        timer.cancel();
        notifyListeners();
      }
      notifyListeners();
    });
  }

  int get getTime => timevalue;
}
