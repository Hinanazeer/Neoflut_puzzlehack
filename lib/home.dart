import 'package:bordered_text/bordered_text.dart';
import 'package:neon/neon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:swipedetector/swipedetector.dart';
import 'dart:io';
import 'board.dart';
import 'game.dart';
import 'dart:core';



class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
   Game game;
   SharedPreferences sharedPreferences;
   Stopwatch stopwatch;
   Future<bool> _onBackPressed() {
     return showDialog(
         context: context,
         builder: (context) => AlertDialog(
           backgroundColor: Colors.black,
           title: const Text(
             "Your current progress will be lost!!!\n Are you sure you want to exit?",
             textAlign: TextAlign.center,
             style: TextStyle(fontSize: 19, letterSpacing: 0.5,color:Colors.lightBlueAccent),
           ),
           actions: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
               FlatButton.icon(
                 onPressed: () {
                   Navigator.pop(context, false);
                 },
                 icon: const Icon(
                   Icons.mood,
                   color: Colors.green,
                 ),
                 textColor: Colors.green,
                 label: const Text('STAY', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
               ),
             FlatButton.icon(
                 onPressed: () => exit(0),
                 icon: const Icon(
                   Icons.sentiment_very_dissatisfied,
                   color: Colors.red,
                 ),
                 textColor: Colors.red,
                 label: const Text('EXIT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
               ),
             ]),
           ],
         ));
   }


   @override
  void initState() {
    game = Game(4);
    super.initState();
  }

  Future<String> getHighScore() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int score = sharedPreferences.getInt('high_score');
    score ??= 0;
    return score.toString();
  }

  Widget _buildHighScoreWidget() {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
          BorderedText(strokeWidth: 1.0, strokeColor: Colors.white,
            child: const Text(
              'High Score',
              style: TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 19,
              ),
            ),),
            FutureBuilder<String>(
              future: getHighScore(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  );
                } else {
                  return const Text(
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBackWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(6.0),
        color:
        game.canUndo() ? Colors.transparent : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GestureDetector(
          child: Icon(
            Icons.undo,
            size: 28.0,
            color: game.canUndo() ? Colors.white : Colors.white70,
          ),
          onTap: () {
            setState(() {
              game.stepBack();
            });
          },
        ),
      ),
    );
  }

  Widget _buildResetWidget() {
   return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding:const EdgeInsets.all(6.0),
        child: GestureDetector(
          child:const Icon(
            Icons.refresh,
            size: 28.0,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              game.resetGame();
            });
          },
        ),
      ),
    );
  }


   Widget _buildScoreWidget() {
     return Container(
       width: 120,
       decoration: BoxDecoration(
         border: Border.all(color: Colors.blueAccent),
         borderRadius: BorderRadius.circular(6.0),
       ),
       child: Padding(
         padding: const EdgeInsets.all(10.0),
         child: Column(
           children: <Widget>[
           BorderedText(strokeWidth: 1.0, strokeColor: Colors.white,
           child:const Text(
               'Score',
               style: TextStyle(
                 color: Colors.pink,
                 fontWeight: FontWeight.bold,
                 letterSpacing: 1,
                 fontSize: 19,
               ),
             ),),
             Text(
               '${game.getScore()}',
               style: const TextStyle(
                 fontSize: 20.0,
                 color: Colors.white,
                 fontWeight: FontWeight.bold,
               ),
             ),
           ],
         ),
       ),
     );
   }

  void updateHighScore() {
    int sc = sharedPreferences.getInt('high_score');
    if (sc == null) {
      sharedPreferences.setInt('high_score', game.getScore());
    }
      else {
      // ignore: unrelated_type_equality_checks
      if (game.getScore() > sc && game.getScore() != sharedPreferences) {
        sharedPreferences.setInt('high_score', game.getScore());
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double gridWidth = (width - 150) / game.gridSize;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child:Scaffold(
      body:Center(
        child:
          Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "gif/bgimg.gif"),
                  fit: BoxFit.cover,
                ),
              ),
              child:
    Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 40),
                   child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:[
                          _buildBackWidget(),
                          _buildResetWidget(),
                        ]),
                ),
                Column(
                  children: [
                    Neon(
              text: 'NEOFLUT',
              color: Colors.pink,
              fontSize: 35,
              font: NeonFont.Membra,
              flickeringText: true,
            ),
            Container(height: 10),
            Neon(
              text: '1024',
              color: Colors.pink,
              fontSize: 25,
              font: NeonFont.Membra,
              flickeringText: true,
            ),
                  ],
                ),
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                      Container(width: 20),
                      _buildScoreWidget(),
                  _buildHighScoreWidget(),
                  Container(width: 20),
                ],
              ),
            SwipeDetector(
              swipeConfiguration: SwipeConfiguration(
                verticalSwipeMinVelocity: 100.0,
                verticalSwipeMinDisplacement: 50.0,
                verticalSwipeMaxWidthThreshold: 100.0,
                horizontalSwipeMaxHeightThreshold: 100.0,
                horizontalSwipeMinDisplacement: 50.0,
                horizontalSwipeMinVelocity: 100.0,
              ),
              onSwipeLeft: () {
                AssetsAudioPlayer.newPlayer().seek(const Duration(milliseconds: 50));
                AssetsAudioPlayer.newPlayer().open(
                  Audio("audios/Click.mp3"),
                  autoStart: true,
//loopMode: LoopMode.single
                );
                game.moveLeft();
                setState(() {
                  updateHighScore();
                });
              },
              onSwipeRight: () {
                AssetsAudioPlayer.newPlayer().seek(const Duration(milliseconds: 50));
                AssetsAudioPlayer.newPlayer().open(
                  Audio("audios/Click.mp3"),
                  autoStart: true,
//loopMode: LoopMode.single
                );
                game.moveRight();
                setState(() {
                  updateHighScore();
                });
              },
              onSwipeUp: () {
                AssetsAudioPlayer.newPlayer().seek(const Duration(milliseconds: 50));
                AssetsAudioPlayer.newPlayer().open(
                  Audio("audios/Click.mp3"),
                  autoStart: true,
//loopMode: LoopMode.single
                );
                game.moveUp();
                setState(() {
                  updateHighScore();
                });
              },
              onSwipeDown: () {
                AssetsAudioPlayer.newPlayer().seek(const Duration(milliseconds: 50));
                AssetsAudioPlayer.newPlayer().open(
                  Audio("audios/Click.mp3"),
                  autoStart: true,
//loopMode: LoopMode.single
                );
                game.moveDown();
                setState(() {
                  updateHighScore();
                });
              },
              child:
                  Board(game, gridWidth),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 30),
              ),
          ],
    ),),

      ),
    ),
    ) ;
  }
}


