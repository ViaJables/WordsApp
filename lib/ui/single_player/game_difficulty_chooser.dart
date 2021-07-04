import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/common_widgets/help_icon.dart';
import 'package:synonym_app/ui/single_player/word_type_chooser.dart';
import 'package:synonym_app/ui/shared/expandable_button.dart';
import 'package:synonym_app/ui/shared/starfield.dart';

class GameDifficultyChooser extends StatefulWidget {
  @override
  _GameDifficultyChooserState createState() => _GameDifficultyChooserState();
}

class _GameDifficultyChooserState extends State<GameDifficultyChooser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
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
                              'HISTORY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
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
              Row(
                children: [
                  Column(
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
                                'CHoose mode'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06,
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
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ExpansionTileBackground(
                                title: 'Timed',
                                children: [
                                  ExpansionTileItem(
                                    txt: 'Easy',
                                    onTap: () => _startGame(Keys.timed,
                                        difficulty: Keys.easy),
                                  ),
                                  ExpansionTileItem(
                                    txt: 'Medium',
                                    onTap: () => _startGame(Keys.timed,
                                        difficulty: Keys.medium),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: ExpansionTileItem(
                                      txt: 'Hard',
                                      onTap: () => _startGame(Keys.timed,
                                          difficulty: Keys.hard),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              ExpansionTileBackground(
                                title: 'Puzzle',
                                children: [
                                  ExpansionTileItem(
                                    txt: 'Timed',
                                    onTap: () => _startGame(
                                      Keys.puzzle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: ExpansionTileItem(
                                      txt: 'Continous',
                                      onTap: () => _startGame(Keys.puzzle,
                                          continuous: true),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _startGame(String type,
      {bool continuous = false, String difficulty = Keys.medium}) {
    Provider.of<QuestionProvider>(context, listen: false).reset();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => WordTypeChooser(
                  gameType: type,
                  continuous: continuous,
                  difficulty: difficulty,
                )));
  }
}
