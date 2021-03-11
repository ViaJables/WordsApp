import 'package:flutter/material.dart';
import 'package:synonym_app/ui/common_widgets/help_page.dart';
import 'package:synonym_app/ui/single_player/history.dart';
import 'package:synonym_app/ui/start_point/walk_trough_page.dart';

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
              .push(MaterialPageRoute(builder: (_) => WalkTroughPage()));
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
      alignment: Alignment.centerRight,
      child: Column(
        children: [
          IconButton(
            icon: Icon(Icons.help),
            color: color,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => WalkTroughPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.person_rounded),
            color: color,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => HelpPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.history),
            color: color,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => Historypage()));
            },
          ),
        ],
      ),
    );
  }
}