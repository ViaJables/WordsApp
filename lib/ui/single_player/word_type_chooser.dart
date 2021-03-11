import 'package:flutter/material.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/common_widgets/help_icon.dart';
import 'package:synonym_app/ui/single_player/sinple_player_game_page.dart';

class WordTypeChooser extends StatelessWidget {
  final String gameType;
  final String difficulty;
  final bool continuous;

  WordTypeChooser({
    @required this.gameType,
    @required this.difficulty,
    @required this.continuous,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(7)),
    );

    final textStyle = TextStyle(
        color: Theme.of(context).accentColor,
        fontWeight: FontWeight.bold,
        fontSize: 17);

    final onTap = (wordType) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SinglePlayerGamePage(
                    gameType: gameType,
                    wordType: wordType,
                    continuous: continuous,
                    difficulty: difficulty,
                  )));
    };

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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'CHoose word type'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                HelpIcon(color: Colors.white),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => onTap(Keys.synonym),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: decoration,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        Keys.synonym.toUpperCase(),
                        style: textStyle,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => onTap(Keys.antonym),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: decoration,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        Keys.antonym.toUpperCase(),
                        style: textStyle,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => onTap(null),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: decoration,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'both'.toUpperCase(),
                        style: textStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
