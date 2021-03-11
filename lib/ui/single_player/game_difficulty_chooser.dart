import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/common_widgets/help_icon.dart';
import 'package:synonym_app/ui/single_player/word_type_chooser.dart';

class GameDifficultyChooser extends StatefulWidget {
  @override
  _GameDifficultyChooserState createState() => _GameDifficultyChooserState();
}

class _GameDifficultyChooserState extends State<GameDifficultyChooser> {
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'CHoose mode'.toUpperCase(),
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _ExpansionTileBackground(
                    title: 'Timed',
                    children: [
                      _ExpansionTileItem(
                        txt: 'Easy',
                        onTap: () =>
                            _startGame(Keys.timed, difficulty: Keys.easy),
                      ),
                      _ExpansionTileItem(
                        txt: 'Medium',
                        onTap: () =>
                            _startGame(Keys.timed, difficulty: Keys.medium),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: _ExpansionTileItem(
                          txt: 'Hard',
                          onTap: () =>
                              _startGame(Keys.timed, difficulty: Keys.hard),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _ExpansionTileBackground(
                    title: 'Puzzle',
                    children: [
                      _ExpansionTileItem(
                        txt: 'Timed',
                        onTap: () => _startGame(
                          Keys.puzzle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: _ExpansionTileItem(
                          txt: 'Continous',
                          onTap: () =>
                              _startGame(Keys.puzzle, continuous: true),
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

class _ExpansionTileBackground extends StatelessWidget {
  final String title;
  final List<Widget> children;

  _ExpansionTileBackground({
    @required this.title,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
        border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: ExpansionTile(
        title: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
        ),
        trailing: SizedBox(height: 1, width: 1),
        children: children,
      ),
    );
  }
}

class _ExpansionTileItem extends StatelessWidget {
  final String txt;
  final Function onTap;

  _ExpansionTileItem({
    @required this.txt,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            side: BorderSide(
                color: Theme.of(context).accentColor.withOpacity(0.5))),
        child: Text(
          txt,
          style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w600),
        ),
        minWidth: double.infinity,
        onPressed: onTap,
      ),
    );
  }
}
