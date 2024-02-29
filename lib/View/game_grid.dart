import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tortoise_world/model/model.dart';
import 'package:provider/provider.dart';

import '../utils.dart';



class GameGrid extends StatefulWidget {
  @override
  State<GameGrid> createState() => _GameGridState();

}
class _GameGridState extends State<GameGrid> {
  int simulationSpeed=200;
  final int rows = 12;
  final int columns = 12;
  List<List<String>> worldMap = [];
  String tortoiseImage="./assets/images/tortoise-n.gif";
  late Tortoise tortoise;
  int eaten=0;
  int score=0;
  int time=0;
  int drinkLevel=MAX_DRINK;
 @override
  void initState() {
    super.initState();
    initializeWorldMap();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      start();
    });
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            SizedBox(height: 20),
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

      if (randomValue < stoneProbability && !isAdjascentToObstacle(x,y)) {
        overlayImage = 'stone';
      } else if (randomValue < stoneProbability + lettuceProbability) {
        overlayImage = 'lettuce';
      } else if (randomValue < stoneProbability + lettuceProbability + pondProbability) {
        overlayImage = 'pond';
      }


        return overlayImage;

    }
  }

  bool isAdjascentToObstacle(int x, int y) {

    bool hasLeftObstacle= (x>0) && (worldMap[x-1][y]=="stone" || worldMap[x-1][y]=="wall");
    bool hasTopObstacle= (y>0) && (worldMap[x][y-1]=="stone" || worldMap[x][y-1]=="wall");
    bool hasTopLeftObstacle= (y>0) &&(x>0) && (worldMap[x-1][y-1]=="stone" || worldMap[x-1][y-1]=="wall");
    return hasLeftObstacle || hasTopObstacle || hasTopLeftObstacle;

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
  void start() {
    tortoise.move();
    tortoiseImage = "./assets/images/" + tortoise.tortoiseImage + ".gif";
    eaten = tortoise.eaten;
    score = tortoise.score;
    drinkLevel = tortoise.drinkLevel;
    time = tortoise.currentTime.toInt();
    setState(() {});
    if (tortoise.action != 'stop') {
      Future.delayed(Duration(milliseconds: 200 ~/ simulationSpeed), start);
    }
  }

  }

class CaseImage extends StatelessWidget {
  final String imageName;
  String tortoiseImage; bool isTortoisePosition;
  CaseImage({required this.imageName, required this.tortoiseImage,required this.isTortoisePosition});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: FittedBox(
        fit: BoxFit.cover,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/ground.gif', // Image de fond (terre)
            ),
            Image.asset(
              imageName,
            ),
            if (isTortoisePosition) Image.asset(tortoiseImage)

          ],
        ),
      ),
    );
  }
}


