import 'package:flutter/material.dart';

class GoBackFlatBtn extends StatelessWidget {
  final bool flag;

  GoBackFlatBtn([this.flag = true]);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: flag ? () => Navigator.pop(context) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.arrow_back_ios,
            color: flag ? Theme.of(context).primaryColor : Colors.transparent,
            size: 17,
          ),
          SizedBox(width: 10),
          Text(
            'Back',
            style: TextStyle(
              color: flag? Theme.of(context).accentColor: Colors.transparent,
              fontSize: 17,
            ),
          )
        ],
      ),
    );
  }
}
