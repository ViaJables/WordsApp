import 'package:flutter/material.dart';
import 'package:synonym_app/models/user.dart';
import 'package:toast/toast.dart';

class StaticInfo {
 // static User currentUser;
  static showToast(BuildContext context, String msg, {int duration = 3}) =>
      Toast.show(
        msg,
        context,
//        textColor: Colors.black,
//        backgroundColor: Colors.white,
        duration: duration,
      );
}
