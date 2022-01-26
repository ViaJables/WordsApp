import 'package:flutter/material.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/start_point/home.dart';
import 'package:synonym_app/ui/shared/starfield.dart';

class PauseScreen extends StatefulWidget {
  final Color color;

  PauseScreen(this.color);

  @override
  _PauseScreenState createState() => _PauseScreenState();
}

class _PauseScreenState extends State<PauseScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _animateFlag;

  @override
  void initState() {
    super.initState();

    _animateFlag = false;

    Future.delayed(Keys.startAnimDuration).then((val) {
      setState(() {
        _animateFlag = !_animateFlag;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: widget.color,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Stack(
                children: [
                  Starfield(),
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'PAUSED',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.07,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: _tappableAnimatedContainer(
                              'RESUME', Theme.of(context).secondaryHeaderColor, () {
                            setState(() {
                              _animateFlag = !_animateFlag;
                            });
                            Future.delayed(Keys.playAnimDuration).then((val) {
                              Navigator.pop(context);
                            });
                          }),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                      SizedBox(height: 30),
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: _tappableAnimatedContainer(
                              'RETRY',
                              Theme.of(context).primaryColor,
                              () => _retryTapped()),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(height: 30),
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: _tappableAnimatedContainer(
                              'QUIT', Colors.white, () => _quitTapped()),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tappableAnimatedContainer(String txt, Color color, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              txt,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }

  _retryTapped() {
    Navigator.pop(context, true);
  }

  _quitTapped() {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => Home()), (_) => false);
  }
}
