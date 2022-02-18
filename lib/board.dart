import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'game.dart';
import 'tile.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  final Game game;
  final double size;
  final double spacing;
  final double padding;

  Board(this.game, this.size , {this.spacing = 5.0, this.padding = 5.0});

  List<Widget> _buildChildren() {
    var children = <Widget>[];
    for (int x = 0; x < game.gridSize; x++) {
      for (int y = 0; y < game.gridSize; y++) {
        var piece = game.getGridValue(y, x);
        children.add(
          Positioned(
            left: y * size + y * spacing,
            top: x * size + x * spacing,
            child: Tile(piece, size, size),
          ),
        );
      }
    }
    return children;
  }

  Widget _buildGameOverWidget(double height) {
    AssetsAudioPlayer.newPlayer().seek(const Duration(milliseconds: 50));
    AssetsAudioPlayer.newPlayer().open(
      Audio("audios/gameover.mp3"),
      autoStart: true,
//loopMode: LoopMode.single
    );
    return Container(
      padding: const EdgeInsets.all(4),
      height: height,
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "gif/gameover.gif"),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
        child: DefaultTextStyle(
        style: const TextStyle(
          fontFamily: 'Overlock-Regular',
        fontSize: 35,
        color: Colors.white,
        shadows: [
        Shadow(
        blurRadius: 7.0,
        color: Colors.white,
        offset: Offset(0, 0),
    ),
    ],
    ),

    child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText('GAME OVER\n'),
              FlickerAnimatedText('GAME OVER\n'),
            ],
            onTap: () {
            },
          ),

        ),
    ),
      ),);
  }

  Widget _buildGameWonWidget(double height) {
    AssetsAudioPlayer.newPlayer().open(
      Audio("audios/Victory.mp3"),
      autoStart: true,
//loopMode: LoopMode.single
    );
     return Container(
      padding: const EdgeInsets.all(4),
      height: height,
      color: Colors.transparent,
      child: Center(
        child:Stack(
      children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "gif/gamewin.gif"),
                fit: BoxFit.cover,
              ),
            ),
             alignment: Alignment.center,
              child: DefaultTextStyle(
                 style: const TextStyle(
                   fontFamily: 'Overlock-Regular',
                 fontSize: 35,
                  color: Colors.white,
                  shadows: [
                            Shadow(
                          blurRadius: 7.0,
                          color: Colors.white,
                          offset: Offset(0, 0),
                      ),
                      ],
                      ),
                      child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                  FlickerAnimatedText('YOU WON!!!\n\n'),
                                FlickerAnimatedText('YOU WON!!!\n\n'),
                              ],
                              onTap: () {
            },
          ),
        ),
      ),
        _buildConfetti(),
        ],
        ),
    ),
    );

  }

  Widget _buildConfetti() {
    return const ConfettiView();
  }

  @override
  Widget build(BuildContext context) {
    var boardSize =
        game.gridSize * size + ((game.gridSize + 3) * spacing - 1 * padding);
    return Container(
      width: boardSize,
      height: boardSize,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(padding),
            child: Stack(
              children: _buildChildren(),
            ),
          ),
          game.gameOver() ? _buildGameOverWidget(boardSize) : const SizedBox(),
          game.gameWon() ? _buildGameWonWidget(boardSize) : const SizedBox(),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.purple),
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }
}

class ConfettiView extends StatefulWidget {
  const ConfettiView({Key key}) : super(key: key);

  @override
  _ConfettiViewState createState() => _ConfettiViewState();
}

class _ConfettiViewState extends State<ConfettiView> {
  ConfettiController _controller;

  @override
  void initState() {
    _controller = ConfettiController(duration: const Duration(seconds: 1));
    _controller.play(); // <-- This causes the confetti to get stuck in one location and flash (when in a showModalBottomSheet)
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        decoration: const BoxDecoration(
            color: Colors.transparent
        ),
        child:
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop:
            true, // start again as soon as the animation is finished
            colors:  [
              Colors.lightBlueAccent,
              Colors.orange,
              Colors.red,
              Colors.yellowAccent,
              Colors.pinkAccent.shade700,
              Colors.lightGreenAccent.shade700,
              Colors.purpleAccent.shade700,
            ], // manually specify the colors to be used
            createParticlePath: drawStar,
            numberOfParticles: 20,
            maxBlastForce: 100,
            minBlastForce: 80,
            gravity: 0.3,
          ),
        ),
    );
  }
}


