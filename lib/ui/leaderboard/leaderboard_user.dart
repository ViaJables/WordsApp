import 'package:flutter/material.dart';

class LeaderboardUser extends StatelessWidget {
  //final LocalUser user;

  LeaderboardUser(

      );

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
        color: Color.fromRGBO(37, 38, 65, 0.7),


        child: Row(
    children: [
        Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Color.fromRGBO(37, 38, 65, 0.7),

            borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
        ),
        Expanded(
        child:
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
        child:
        Text(
          "Title",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w100,
              fontSize:  MediaQuery.of(context).size.width * 0.04),
          textAlign: TextAlign.left,
        ),),),
      Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Color.fromRGBO(37, 38, 65, 0.7),

          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      ],
    ),
    );
  }
}