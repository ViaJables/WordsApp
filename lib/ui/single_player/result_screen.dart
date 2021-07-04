import 'package:flutter/material.dart';
import 'package:synonym_app/ui/common_widgets/page_background.dart';
import 'package:synonym_app/ui/start_point/home.dart';

class ResultScreen extends StatefulWidget {
  final String timedOrContinous;
  final String difficulty;
  final int rightAns, wrongAns;

  const ResultScreen({
    @required this.timedOrContinous,
    @required this.difficulty,
    @required this.rightAns,
    @required this.wrongAns,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return PageBackground(
      appBarColor: Colors.white,
      title: 'results',
      child: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${widget.timedOrContinous}-${widget.difficulty}'
                        .toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 27),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'right'.toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Text(
                    '${widget.rightAns}',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 25),
                  ),
                  Text(
                    'wrong'.toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Text(
                    '${widget.wrongAns}',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 25),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Dismissible(
                      key: Key('next'),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (dir) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => Home()),
                            (_) => false);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Center(
                          child: Text(
                            'next >'.toUpperCase(),
                            style: TextStyle(
                              // color: Theme.of(context).primaryColor,
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/arrow_left_blue.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Dismissible(
                      key: Key('quite'),
                      direction: DismissDirection.endToStart,
                      onDismissed: (dir) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => Home()),
                            (_) => false);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Center(
                          child: Text(
                            '< quit'.toUpperCase(),
                            style: TextStyle(
                              // color: Theme.of(context).primaryColor,
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/arrow_right_red.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
