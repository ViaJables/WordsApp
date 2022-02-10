import 'package:flutter/material.dart';
import 'package:synonym_app/ui/leaderboard/leaderboard_user.dart';
import 'package:synonym_app/ui/leaderboard/leaderboard_user_me.dart';
import 'package:synonym_app/models/localuser.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<LocalUser> userList;
  final String myUID;
  final int filterMethod; // 0: Daily, 1: Weekly, 2: Monthly

  LeaderboardWidget({
    required this.userList,
    required this.myUID,
    required this.filterMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                SizedBox(height: 60.0),
                Stack(children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset("assets/leaderboard/second_place.png"),
                  ),
                ]),
                SizedBox(height: 5),
                Text(
                  '${userList[1].userName}',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0),
                ),
                SizedBox(height: 15.0),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(76, 76, 76, 0.3),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 5)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                  child: Text(
                    '${numPoints(userList[1])}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Stack(children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset("assets/leaderboard/first_place.png"),
                  ),
                ]),
                SizedBox(height: 5),
                Text(
                  '${userList[0].userName}',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0),
                ),
                SizedBox(height: 15.0),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(76, 76, 76, 0.3),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 5)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                  child: Text(
                    '${numPoints(userList[0])}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 120.0),
                Stack(children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 4.5,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset("assets/leaderboard/third_place.png"),
                  ),
                ]),
                SizedBox(height: 5),
                Text(
                  '${userList[2].userName}',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0),
                ),
                SizedBox(height: 15.0),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(76, 76, 76, 0.3),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 5)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                  child: Text(
                    '${numPoints(userList[2])}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 15.0),
        Container(
          height: 1.0,
          width: double.infinity,
          color: Theme.of(context).secondaryHeaderColor,
        ),
        Container(
          height: 15.0,
          width: double.infinity,
          color: Color.fromRGBO(37, 38, 65, 0.7),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                var user = userList[index];
                if (user.uid == myUID) {
                  return LeaderboardUserMe(
                      user: userList[index], rank: index + 1, points: numPoints(userList[index]));
                } else {
                  return LeaderboardUser(
                      user: userList[index], rank: index + 1, points: numPoints(userList[index]));
                }
              }),
        ),
      ],
    );
  }

  numPoints(LocalUser user) {
    if (filterMethod == 0) {
      return user.daysPoints;
    } else if (filterMethod == 1) {
      return user.weeksPoints;
    } else {
      return user.monthsPoints;
    }
  }
}
