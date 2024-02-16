import 'package:flutter/material.dart';
import 'dart:math';

class GameGrid extends StatelessWidget {
  final int rows = 12;
  final int columns = 12;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
      ),
      itemBuilder: (BuildContext context, int index) {
        String imageName = getImageName(index);
        return CaseImage(imageName: imageName);
      },
      itemCount: rows * columns,
    );
  }

  String getImageName(int index) {
    int x = index % columns;
    int y = index ~/ columns;

    if (x == 1 && y == 1) {
      return 'assets/images/tortoise-s.gif';
    } else if (x == 0 || x == columns - 1 || y == 0 || y == rows - 1) {
      return 'assets/images/wall.gif';
    } else {
      double stoneProbability = 0.1;
      double lettuceProbability = 0.2;
      double pondProbability = 0.1;

      double randomValue = Random().nextDouble();

      String overlayImage = 'assets/images/ground.gif'; // Image de fond (terre)

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
