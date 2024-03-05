import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tortoise_world/Model/model.dart';
import 'package:tortoise_world/utils.dart';

import 'case.dart';

void main() {
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Jeu de la Tortue'),
        ),
        body: Center(
          child: GameScreen(),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  int simulationSpeed = 30;
  final int rows = 12;
  final int columns = 12;
  List<List<String>> worldMap = [];
  String tortoiseImage = "./assets/images/tortoise-n.gif";
  late Tortoise tortoise;
  int eaten = 0;
  int score = 0;
  int time = 0;
  int drinkLevel = MAX_DRINK;
  late Ticker _ticker;
  double cumulativeTime=0;



  @override
  void initState() {
    super.initState();
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

    tortoise = Tortoise(worldMap: worldMap);
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
      } else if (randomValue <
          stoneProbability + lettuceProbability + pondProbability) {
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

  void _update(Duration elapsed) {
    setState(() {
      double frameTime = elapsed.inMicroseconds / 1000.0;
      cumulativeTime+=frameTime;
      if(cumulativeTime>DELAY_IN_MS && tortoise.moveCount<=MAX_TIME && tortoise.action!="stop"){
        cumulativeTime=0;
        tortoise.moveTortoise();
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
    return  SingleChildScrollView(
      child: Container(
        width: 500,
        height: 600,
        padding: EdgeInsets.all(16.0),
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
                bool isTortoisePositon =
                    tortoise.xpos == x && tortoise.ypos == y;
                return CaseImage(
                  imageName: getImageFromType(worldMap[y][x]),
                  tortoiseImage: tortoiseImage,
                  isTortoisePosition: isTortoisePositon,
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