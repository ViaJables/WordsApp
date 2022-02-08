import 'package:flutter/material.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:synonym_app/ui/single_player/pregame/word_type_chooser.dart';
import 'package:bouncing_widget/bouncing_widget.dart';

class GameDifficultyChooser extends StatelessWidget {
  final String gameType;
  final bool continuous;

  GameDifficultyChooser({
    required this.gameType,
    required this.continuous,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            new Starfield(),
            Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Select Difficulty',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.09,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 60),
                        BouncingWidget(
                          duration: Duration(milliseconds: 30),
                          scaleFactor: 1.5,
                          onPressed: () {
                            toWordChooser(context, Keys.easy);
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(37, 38, 65, 0.7),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                              border: Border.all(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "Easy",
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 28),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        BouncingWidget(
                          duration: Duration(milliseconds: 30),
                          scaleFactor: 1.5,
                          onPressed: () {
                            toWordChooser(context, Keys.medium);
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(37, 38, 65, 0.7),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "Medium",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 28),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        BouncingWidget(
                          duration: Duration(milliseconds: 30),
                          scaleFactor: 1.5,
                          onPressed: () {
                            toWordChooser(context, Keys.hard);
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(37, 38, 65, 0.7),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "Hard",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
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

  toWordChooser(BuildContext context, difficulty) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => WordTypeChooser(
              gameType: gameType,
              continuous: false,
              difficulty: difficulty,
            ),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 100),
          ));
    });
  }
}
