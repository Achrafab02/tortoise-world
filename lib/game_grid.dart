// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'tortoiseWorld.dart';

class GameGrid extends StatelessWidget {
  TortoiseWorld tortoiseWorld = TortoiseWorld(12);
  GameGrid() : tortoiseWorld = TortoiseWorld(12);

  int get rows => tortoiseWorld.grid_size;
  int get columns => tortoiseWorld.grid_size;

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
    String img = tortoiseWorld.worldmap[y][x];
    print(img);
    if (img == 'wall') {
      return 'assets/images/wall.gif';
    } else if (img == 'lettuce') {
      return 'assets/images/lettuce.gif';
    } else if (img == 'pond') {
      return 'assets/images/pond.gif';
    } else if (img == 'stone') {
      return 'assets/images/stone.gif';
    } else if (img == 'tortoise-n') {
      return 'assets/images/tortoise-n.gif';
    } else if (img == 'tortoise-s') {
      return 'assets/images/tortoise-s.gif';
    } else if (img == 'tortoise-w') {
      return 'assets/images/tortoise-w.gif';
    } else if (img == 'tortoise-e') {
      return 'assets/images/tortoise-e.gif';
    } else if (img == 'tortoise-dead') {
      return 'assets/images/tortoise-dead.gif';
    } else if (x==1 && y==1) {
      print('entred the condition');
      return 'assets/images/tortoise-s.gif';
    } else {
      return 'assets/images/ground.gif';
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
        border: null,
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
