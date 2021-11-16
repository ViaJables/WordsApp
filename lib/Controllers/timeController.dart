import 'dart:async';

import 'package:get/get.dart';

class TimerController extends GetxController {
  var timer;
  var timevalue = 0.obs;

  setTimer(int newTime) {
    timevalue.value = newTime;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timevalue.value = timevalue.value; //- 1;
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
