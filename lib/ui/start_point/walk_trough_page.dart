import 'package:flutter/material.dart';
import 'package:synonym_app/ui/start_point/home.dart';

class WalkTroughPage extends StatefulWidget {
  @override
  _WalkTroughPageState createState() => _WalkTroughPageState();
}

class _WalkTroughPageState extends State<WalkTroughPage> {
  bool flag;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.045,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).accentColor,
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              onPageChanged: (index) {
                if (flag == null &&
                    index ==
                        4) // this number is length of children and it must be n-1
                  setState(() {
                    flag = true;
                  });
              },
              children: <Widget>[
                Icon(Icons.extension, size: 100),
                Icon(Icons.language, size: 100),
                Icon(Icons.weekend, size: 100),
                Icon(Icons.wb_auto, size: 100),
                Icon(Icons.toys, size: 100),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => Home()),
                        (route) => false);
                  },
                  child: Text('SKIP', style: style),
                ),
                flag == true
                    ? FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => Home()),
                              (route) => false);
                        },
                        child: Text('FINISH', style: style),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
