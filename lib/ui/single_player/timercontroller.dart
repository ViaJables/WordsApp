import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerController with ChangeNotifier {
  int timevalue;
  int pauseValue = 0;
  Timer timer;

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
