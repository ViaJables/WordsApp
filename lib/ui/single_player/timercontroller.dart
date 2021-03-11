import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/single_player/result_screen.dart';

class Timercontroller with ChangeNotifier {
   int timevalue;
  Timer timer;

   settimer(int newtime,BuildContext context) {
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
