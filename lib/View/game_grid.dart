import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import '../model/model.dart';
class PositionTortoise{
  int x=1;
  int y=1;
}
class GameGrid extends StatefulWidget {
  @override
  State<GameGrid> createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  final int rows = 12;
  final int columns = 12;
  List<List<String>> mapImages = [];
  List<List<String>> mapTiles = [];
  PositionTortoise positionTortoise = new PositionTortoise();
  List<String> directionTortoiseImageTable = [
    'tortoise-n',
    'tortoise-e',
    'tortoise-s',
    'tortoise-w'
  ];



  @override
  void initState() {
    super.initState();
    initializeWorldMap();
    Timer(Duration(seconds: 3), () {
      moveTortoise(positionTortoise);
    });
    setState(() {

    });
  }

  void initializeWorldMap() {
    for (int i = 0; i < rows; i++) {
      List<String> rowImages = [];
      List<String> rowTypes = [];
      for (int j = 0; j < columns; j++) {
        String imageName = getImageName(i, j);
        rowImages.add(imageName);
        String tileType = getTileTypeFromImage(imageName);
        rowTypes.add(tileType);
      }
      mapImages.add(rowImages);
      mapTiles.add(rowTypes);
    }
  }

  String getTileTypeFromImage(String imageName) {
    switch (imageName) {
      case 'assets/images/tortoise-s.gif':
        return 'tortoise';
      case 'assets/images/stone.gif':
        return 'stone';
      case 'assets/images/lettuce.gif':
        return 'lettuce';
      case 'assets/images/pond.gif':
        return 'pond';
      case 'assets/images/ground.gif':
        return 'ground';
      case 'assets/images/wall.gif':
        return 'wall';
      default:
        return '';
    }
  }


  void moveTortoise(PositionTortoise positionTortoise) {
    setState(() {
      Tortoise tortoise = Tortoise(positionTortoise: positionTortoise, mapImages: mapImages, mapTiles: mapTiles);

      tortoise.move(columns, rows);
      redrawTortoise(tortoise.direction,tortoise.update);
    });

    Timer(Duration(seconds: 1), () {
      moveTortoise(positionTortoise);
    });
  }





  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
      ),
      itemBuilder: (BuildContext context, int index) {
        int x = index % columns;
        int y = index ~/ columns;
        return CaseImage(imageName: mapImages[y][x]);
      },
      itemCount: rows * columns,
    );
  }

  String getImageName(int x, int y) {
    if (x == 1 && y == 1) {
      return 'assets/images/tortoise-s.gif';
    } else if (x == 0 || x == columns - 1 || y == 0 || y == rows - 1) {
      return 'assets/images/wall.gif';
    } else {
      double stoneProbability = 0.1;
      double lettuceProbability = 0.2;
      double pondProbability = 0.1;

      double randomValue = Random().nextDouble();

      String overlayImage = 'assets/images/ground.gif';

      if (randomValue < stoneProbability) {
        overlayImage = 'assets/images/stone.gif';
      } else if (randomValue < stoneProbability + lettuceProbability) {
        overlayImage = 'assets/images/lettuce.gif';
      } else if (randomValue < stoneProbability + lettuceProbability + pondProbability) {
        overlayImage = 'assets/images/pond.gif';
      }

      if (x == 1 && y == 1) {
        return 'assets/images/tortoise-s.gif';
      } else {
        return overlayImage;
      }
    }
  }

  void redrawTortoise(int direction,bool update) {
    //print(directionTortoiseImageTable[direction]);
    if(update==true) {
      mapTiles[positionTortoise.x][positionTortoise.y] = 'tortoise';
      String directionImage = 'assets/images/${directionTortoiseImageTable[direction]}.gif';
      mapImages[positionTortoise.x][positionTortoise.y] = directionImage;
    }
  }

  }





class CaseImage extends StatelessWidget {
  final String imageName;

  CaseImage({required this.imageName});

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
          ],
        ),
      ),
    );
  }
}
