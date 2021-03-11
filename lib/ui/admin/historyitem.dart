import 'package:flutter/material.dart';
class HistoryItem{
  String question,answergiven,correctanswer,qid;

  HistoryItem({this.question, this.answergiven, this.correctanswer, this.qid});

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return new HistoryItem(
      question: map['question'] as String,
      answergiven: map['answergiven'] as String,
      correctanswer: map['correctanswer'] as String,
      qid: map['qid'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'question': this.question,
      'answergiven': this.answergiven,
      'correctanswer': this.correctanswer,
      'qid': this.qid,
    } as Map<String, dynamic>;
  }
  @override
  String toString() {
    return 'HistoryItem{question: $question, answergiven: $answergiven, correctanswer: $correctanswer, qid: $qid}';
  }

}