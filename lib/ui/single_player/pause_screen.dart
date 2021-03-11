import 'package:flutter/material.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/start_point/home.dart';

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
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'PAUSE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Container(),
                  onPressed: null,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: _tappableAnimatedContainer('resume', () {

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
                      padding: const EdgeInsets.only(right: 20),
                      child: _tappableAnimatedContainer(
                          'retry', () => _showConfirmBotomSheet('retry')),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  SizedBox(height: 30),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: _tappableAnimatedContainer(
                          'quit', () => _showConfirmBotomSheet('quite')),
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );


  }

  Widget _tappableAnimatedContainer(String txt, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Keys.playAnimDuration,
        color: Theme.of(context).primaryColor,
        height: MediaQuery.of(context).size.height * 0.15,
        width: _animateFlag ? MediaQuery.of(context).size.width : 150,
        child: Center(
          child: Text(
            txt.toUpperCase(),
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
    );
  }

  _showConfirmBotomSheet(String type) {
    _scaffoldKey.currentState.showBottomSheet((_) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      type.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      type == 'retry'
                          ? 'By hitting retry you will be restarting from round 1.\nAll points will be lost.\nAre you sure?'
                              .toUpperCase()
                          : 'By hitting quit you will return to main menu. all points will be lost'
                              .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  if (type == 'retry') {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  } else
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => Home()),
                        (_) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Text(
                        'YES',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Text(
                        'NO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }, elevation: 100);
  }
}
