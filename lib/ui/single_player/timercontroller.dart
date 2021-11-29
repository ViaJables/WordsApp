import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerController with ChangeNotifier {
  int timevalue;
  Timer timer;

  setTimer(int newtime) {
    timevalue = newtime;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timevalue = timevalue - 1;
      if (timevalue == 0) {
        timer.cancel();
        notifyListeners();
      }
      notifyListeners();
    });
  }

  int get Gettime => timevalue;
}
