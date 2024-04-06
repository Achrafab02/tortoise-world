import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tortoise_world/model/model.dart';
import 'package:tortoise_world/presenter/LLGrammarPresenter/GrammarPresenter.dart';
import 'package:tortoise_world/view/utils.dart';

import 'case.dart';

// TODO Une god class: refondre la classe en sous-classes.
// TODO Inclure le respect des règles du jeu, ce n'est pas à l'élève d'empêcher de monter sur un mur.
// TODO Empecher d'écrire tant que le programme n'est pas fini (ou arrêté).
// TODO revoir entièrement la communication entre l'éditeur et le moteur de jeu.
class GameScreen extends StatefulWidget {
  final GrammarPresenter presenter;

  const GameScreen(this.presenter, {super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final int rows = 12;
  final int columns = 12;
  List<List<String>> worldMap = [];
  String tortoiseImage = "./assets/images/tortoise-e.gif";
  late final Tortoise tortoise;
  int eaten = 0;
  int score = 0;
  int time = 0;
  int drinkLevel = MAX_DRINK;
  late Ticker _ticker;
  double cumulativeTime = 0;

  @override
  void initState() {
    super.initState();
    tortoise = widget.presenter.tortoise;
    initializeWorldMap();
    _ticker = createTicker((elapsed) => _update(elapsed));

    _ticker.start();
  }

  void initializeWorldMap() {
    int countLettuce = 0;
    for (int i = 0; i < rows; i++) {
      List<String> rowTypes = [];
      for (int j = 0; j < columns; j++) {
        rowTypes.add("ground");
      }
      worldMap.add(rowTypes);
    }

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        String type = selectTileType(j, i);
        worldMap[i][j] = type;
        if (type == 'lettuce') {
          countLettuce++;
        }
      }
    }

    tortoise.worldMap = worldMap;
    tortoise.updateLettuceCount(countLettuce);
  }

  String selectTileType(int x, int y) {
    if (x == 1 && y == 1) {
      return 'pond';
    } else if (x == 0 || x == columns - 1 || y == 0 || y == rows - 1) {
      return 'wall';
    } else {
      double stoneProbability = 0.1;
      double lettuceProbability = 0.2;
      double pondProbability = 0.1;

      double randomValue = Random().nextDouble();

      String overlayImage = 'ground';

      if (randomValue < stoneProbability) {
        overlayImage = 'stone';
      } else if (randomValue < stoneProbability + lettuceProbability) {
        overlayImage = 'lettuce';
      } else if (randomValue < stoneProbability + lettuceProbability + pondProbability) {
        overlayImage = 'pond';
      }

      return overlayImage;
    }
  }

  String getImageFromType(String tileType) {
    switch (tileType) {
      case 'pond':
        return 'assets/images/pond.gif';
      case 'lettuce':
        return 'assets/images/lettuce.gif';
      case 'wall':
        return 'assets/images/wall.gif';
      case 'stone':
        return 'assets/images/stone.gif';
      default:
        return 'assets/images/ground.gif';
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void showresultDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _update(Duration elapsed) {
    setState(() {
      cumulativeTime += 1500;
      if (cumulativeTime > DELAY_IN_MS && tortoise.moveCount <= MAX_TIME && tortoise.action != "stop") {
        cumulativeTime = 0;
        print("ici...");
        if (widget.presenter.tortoiseBrain.parser == null) {
          return;
        }
        String result = tortoise.moveTortoise(widget.presenter.tortoise.think(widget.presenter.tortoiseBrain.parser!.resultMap.data));
        if (result == "Vous êtes mort de soif!") {
          _ticker.stop();
          showresultDialog(context, result);
        }
        if (result == "Vous êtes mort de faim!") {
          _ticker.stop();
          showresultDialog(context, result);
        }
        tortoiseImage = "./assets/images/${tortoise.tortoiseImage}.gif";
        eaten = tortoise.eaten;
        score = tortoise.score;
        drinkLevel = tortoise.drinkLevel;
        time = tortoise.moveCount;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 500,
        height: 600,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
              ),
              itemBuilder: (BuildContext context, int index) {
                int x = index % columns;
                int y = index ~/ columns;
                bool isTortoisePosition = tortoise.xpos == x && tortoise.ypos == y;
                return CaseImage(
                  imageName: getImageFromType(worldMap[y][x]),
                  tortoiseImage: tortoiseImage,
                  isTortoisePosition: isTortoisePosition,
                );
              },
              itemCount: rows * columns,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Eaten: $eaten "),
                Text("Time: $time "),
                Text("Score: $score "),
                Text("Drink Level: $drinkLevel "),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
