import 'dart:ui';

import 'package:flutter/material.dart';

class ExpansionTileBackground extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color color;

  ExpansionTileBackground({
    required this.title,
    required this.children,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(left: 30),
        child: ExpansionTile(
          title: Container(
            width: MediaQuery.of(context).size.width + 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromRGBO(37, 38, 65, 0.7),
              borderRadius: BorderRadius.all(Radius.circular(30)),
              border: Border.all(color: color, width: 1),
            ),
            padding: EdgeInsets.symmetric(vertical: 15),
            child:
            Padding(
            padding: EdgeInsets.only(right: 15.0),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Icon(
              Icons.play_arrow,
                color: Colors.white,
                size: 32.0,
              ),
            SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 25),
            ),
            ],
            ),
          ),
          ),
          backgroundColor: Colors.transparent,
          trailing: SizedBox.shrink(),
          children: children,
        ),
      ),
    );
  }
}

class ExpansionTileItem extends StatelessWidget {
  final String txt;
  final Color backgroundColor;
  final Function()? onTap;

  ExpansionTileItem({
    required this.txt,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 30),
        child: MaterialButton(
          child: Text(
            txt,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 25),
          ),
          minWidth: double.infinity,
          onPressed: onTap,
        ),
      ),
    );
  }
}
