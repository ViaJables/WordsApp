import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:synonym_app/res/keys.dart';

class Question extends Equatable {
  final String id, word, synonymOrAntonym;
  final int correctAnswer;
  final List<String> answers;

  Question({
    @required this.id,
    @required this.word,
    @required this.synonymOrAntonym,
    @required this.correctAnswer,
    @required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'word': this.word,
      'synonymOrAntonym': this.synonymOrAntonym,
      'correctAnswer': this.correctAnswer,
      'answers': this.answers,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return new Question(
        id: map['id'] as String,
        word: map['word'] as String,
        synonymOrAntonym: map['synonymOrAntonym'] as String,
        correctAnswer: map['correctAnswer'] as int,
        answers: List.from(map['answers']));
  }

  @override
  String toString() {
    return 'Question{id: $id, word: $word, synonymOrAntonym: $synonymOrAntonym, correctAnswer: $correctAnswer, answers: $answers}';
  }

  @override
  // TODO: implement props
  List<Object> get props => [id, word, synonymOrAntonym];
}

class QuestionProvider {
  List<Question> _askedQuestions;
  Random _random;

  QuestionProvider() {
    _random = Random();
    _askedQuestions = List<Question>();
  }

  void reset() => _askedQuestions.clear();

  Future<Question> getRandomQuestion() async {
    Question question;

    while (true) {
      int randomNum = _random.nextInt(4);
      var result = (await Firestore.instance
              .collection(Keys.questions)
              .where('correctAnswer', isEqualTo: randomNum)
              .getDocuments())
          .documents;

      if (result.length == 0) continue;
      if (result.length >= _askedQuestions.length / 1.5)
        _askedQuestions.clear();

      while (true) {
        var doc = Question.fromMap(result[_random.nextInt(result.length)].data);
        if (!_askedQuestions.contains(doc)) {
          question = doc;
          break;
        }
      }
      if (question != null) break;
    }
    _askedQuestions.add(question);

    return question;
  }
}
