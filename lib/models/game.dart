
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/models/result.dart';

class GameInProgress {
  String id, playingWith, turn;
  Question currentQuestion;
  int remainingTurns, correctAns, wrongAns;

  GameInProgress({
    required this.id,
    required this.playingWith,
    required this.turn,
    required this.remainingTurns,
    required this.correctAns,
    required this.wrongAns,
    required this.currentQuestion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'playingWith': this.playingWith,
      'turn': this.turn,
      'currentQuestion': this.currentQuestion.toMap(),
      'remainingTurns': this.remainingTurns,
      'correctAns': this.correctAns,
      'wrongAns': this.wrongAns,
    };
  }

  factory GameInProgress.fromMap(Map<String, dynamic> map) {
    return new GameInProgress(
      id: map['id'] as String,
      playingWith: map['playingWith'] as String,
      turn: map['turn'] as String,
      currentQuestion: Question.fromMap(Map.from(map['currentQuestion'])),
      remainingTurns: map['remainingTurns'] as int,
      correctAns: map['correctAns'] as int,
      wrongAns: map['wrongAns'] as int,
    );
  }

  @override
  String toString() {
    return 'GameInProgress{currentQuestion: $currentQuestion, playingWith: $playingWith, turn: $turn, remainingTurns: $remainingTurns, correctAns: $correctAns, wrongAns: $wrongAns}';
  }
}

class CompletedGame {
  String userAUid, userBUid, winnerUid;
  Result userAResult, userBResult;

  CompletedGame({
    required this.userAUid,
    required this.userBUid,
    required this.winnerUid,
    required this.userAResult,
    required this.userBResult,
  });

  Map<String, dynamic> toMap() {
    return {
      'userAUid': this.userAUid,
      'userBUid': this.userBUid,
      'winnerUid': this.winnerUid,
      'userAResult': this.userAResult.toMap(),
      'userBResult': this.userBResult.toMap(),
    };
  }

  factory CompletedGame.fromMap(Map<String, dynamic> map) {
    return new CompletedGame(
      userAUid: map['userAUid'] as String,
      userBUid: map['userBUid'] as String,
      winnerUid: map['winnerUid'] as String,
      userAResult: Result.fromMap(Map.from(map['userAResult'])),
      userBResult: Result.fromMap(Map.from(map['userBResult'])),
    );
  }

  @override
  String toString() {
    return 'CompletedGame{userAUid: $userAUid, userBUid: $userBUid, winnerUid: $winnerUid}';
  }
}
