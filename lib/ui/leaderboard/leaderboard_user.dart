import 'package:flutter/material.dart';
import 'package:synonym_app/models/localuser.dart';

class LeaderboardUser extends StatelessWidget {
  final LocalUser user;
  final int rank;
  final int points;

  LeaderboardUser({required this.user, required this.rank, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      color: Color.fromRGBO(37, 38, 65, 0.7),
      child: Row(
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Color.fromRGBO(37, 38, 65, 0.7),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Center(
              child: Text(
                "$rank",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "${user.userName}",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: MediaQuery.of(context).size.width * 0.04),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Color.fromRGBO(143, 143, 191, 0.3),
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
            child: Center(
              child: Text(
                "${points}",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: 12.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
