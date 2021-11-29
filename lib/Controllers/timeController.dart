import 'dart:async';

import 'package:get/get.dart';

class OldTimerController extends GetxController {
  var timer;
  var timevalue = 0.obs;

  setTimer(int newTime) {
    timevalue.value = newTime;
    print("Setup 2");
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timevalue.value = timevalue.value - 1;
      print("New value is ${timevalue.value}");

      if (timevalue.value == 0) {
        timer.cancel();
      }
      // Get.to(ResultScreen(
      //   timedOrContinous: Keys.timed,
      //   difficulty: widget.difficulty,
      //   rightAns: _correctAnswers,
      //   wrongAns: _wrongAnswers,
      // ));
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    timer.cancel();

    super.onClose();
  }
}
