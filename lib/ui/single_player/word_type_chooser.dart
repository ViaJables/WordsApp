import 'package:flutter/material.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/single_player/single_player_game_page.dart';
import 'package:synonym_app/ui/shared/starfield.dart';

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
      color: Colors.transparent,
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      border: Border.all(color: Theme.of(context).accentColor, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(7)),
    );

    final textStyle = TextStyle(
        color: Theme.of(context).accentColor,
        fontWeight: FontWeight.bold,
        fontSize: 28);

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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            new Starfield(),
            Column(
              children: [
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
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'CHOOSE WORD TYPE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () => onTap(Keys.synonym),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                              border: Border.all(
                                  color: Theme.of(context).accentColor,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              Keys.synonym.toUpperCase(),
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () => onTap(Keys.antonym),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              Keys.antonym.toUpperCase(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () => onTap(null),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'both'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
