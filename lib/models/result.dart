import 'package:flutter/foundation.dart';

class Result {
  String uid, name;
  int correctAns, wrongAns;

  Result({
    @required this.uid,
    @required this.name,
    @required this.correctAns,
    @required this.wrongAns,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'name': this.name,
      'correctAns': this.correctAns,
      'wrongAns': this.wrongAns,
    };
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return new Result(
      uid: map['uid'] as String,
      name: map['name'] as String,
      correctAns: map['correctAns'] as int,
      wrongAns: map['wrongAns'] as int,
    );
  }

  @override
  String toString() {
    return 'Result{uid: $uid, name: $name, correctAns: $correctAns, wrongAns: $wrongAns}';
  }
}
