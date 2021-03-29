import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/models/game.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/common_widgets/page_bacground.dart';
import 'package:synonym_app/ui/multi_player/multi_player_game.dart';

class NewGame extends StatefulWidget {
  final LocalUser user;
  final GameInProgress game;

  NewGame(this.user, this.game);

  @override
  _NewGameState createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  bool _animFlag;

  @override
  void initState() {
    super.initState();

    _animFlag = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'NEW GAME',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Multiplayer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ],
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
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _animFlag = !_animFlag;
                });
                Future.delayed(Keys.playAnimDuration).then((val) {
                  Provider.of<QuestionProvider>(context, listen: false).reset();

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => MultiPlayerGame(widget.game)));
                });
              },
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedAlign(
                      alignment: _animFlag
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      duration: Keys.playAnimDuration,
                      child: AnimatedOpacity(
                        duration: Keys.playAnimDuration,
                        opacity: _animFlag ? 0 : 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('assets/arrow_left_blue.png'),
                            fit: BoxFit.cover,
                          )),
                          child: _child(Provider.of<LocalUser>(context)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        'VS',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AnimatedAlign(
                      alignment: _animFlag
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      duration: Keys.playAnimDuration,
                      child: AnimatedOpacity(
                        duration: Keys.playAnimDuration,
                        opacity: _animFlag ? 0 : 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.4,
                          height: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('assets/arrow_right_red.png'),
                            fit: BoxFit.cover,
                          )),
                          child: _child(widget.user),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          _animFlag = !_animFlag;
        });
        Future.delayed(Keys.playAnimDuration).then((val) {
          Provider.of<QuestionProvider>(context, listen: false).reset();

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => MultiPlayerGame(widget.game)));
        });
      },
      child: PageBacground(
        title: 'New Game',
        appBarColor: Theme.of(context).primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedAlign(
                alignment:
                    _animFlag ? Alignment.centerRight : Alignment.centerLeft,
                duration: Keys.playAnimDuration,
                child: AnimatedOpacity(
                  duration: Keys.playAnimDuration,
                  opacity: _animFlag ? 0 : 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/blue_arrow_right.png'),
                      fit: BoxFit.cover,
                    )),
                    child: _child(Provider.of<LocalUser>(context)),
                  ),
                ),
              ),
              AnimatedAlign(
                alignment:
                    _animFlag ? Alignment.centerLeft : Alignment.centerRight,
                duration: Keys.playAnimDuration,
                child: AnimatedOpacity(
                  duration: Keys.playAnimDuration,
                  opacity: _animFlag ? 0 : 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/red_arrow_left.png'),
                      fit: BoxFit.cover,
                    )),
                    child: _child(widget.user),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _child(LocalUser user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          user.uid == Provider.of<LocalUser>(context).uid ? 'YOU' : user.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),
        user.uid == Provider.of<LocalUser>(context).uid
            ? Container()
            : CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                child: user.image == ''
                    ? Icon(
                        Icons.person,
                        color: Colors.white,
                      )
                    : null,
//          backgroundImage: user.image == ''
//              ? null
//              : MemoryImage(Base64Decoder().convert(user.image)),
              ),
      ],
    );
  }
}
