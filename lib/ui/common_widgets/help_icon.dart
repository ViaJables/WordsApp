import 'package:flutter/material.dart';
import 'package:synonym_app/ui/profile/help_page.dart';
import 'package:synonym_app/ui/single_player/history.dart';
import 'package:synonym_app/ui/start_point/walk_through_page.dart';

class HelpIcon extends StatelessWidget {
  final Color color;

  const HelpIcon({this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: Icon(Icons.help),
        color: color,
        onPressed: () {
          print("working");
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => WalkThroughPage()));
        },
      ),
    );
  }
}

class AllThree extends StatelessWidget {
  final Color color;

  const AllThree({this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new SizedBox(
            height: MediaQuery.of(context).size.width * 0.075,
            width: MediaQuery.of(context).size.width * 0.075,
            child: new IconButton(
              icon: Icon(Icons.history,
                  size: MediaQuery.of(context).size.width * 0.075),
              color: Colors.grey,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Historypage()));
              },
            ),
          ),
          SizedBox(width: 15),
          new SizedBox(
            height: MediaQuery.of(context).size.width * 0.075,
            width: MediaQuery.of(context).size.width * 0.075,
            child: new IconButton(
              icon: Icon(Icons.person_rounded,
                  size: MediaQuery.of(context).size.width * 0.075),
              color: Colors.grey,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => HelpPage()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
