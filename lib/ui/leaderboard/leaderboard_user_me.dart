import 'package:flutter/material.dart';
import 'package:synonym_app/models/localuser.dart';

class LeaderboardUserMe extends StatelessWidget {
  final LocalUser user;
  final int rank;
  final int points;

  LeaderboardUserMe({required this.user, required this.rank, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Container(
            width: 60.0,
            height: 60.0,
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
                    fontSize: 22.0),
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
