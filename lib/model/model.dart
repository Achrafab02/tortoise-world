import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

import '../View/game_grid.dart';
import 'agent.dart';

class Tortoise {
  int direction = 0;
  PositionTortoise positionTortoise = new PositionTortoise();
  TortoiseBrain brain = TortoiseBrain();
  List<List<String>> mapImages = [];
  List<List<String>> mapTiles = [];
  List<List<int>> direction_table = [
    [0, -1],
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, 0]
  ];
  bool update=true;


  Tortoise({required this.positionTortoise, required List<
      List<String>> mapImages, required List<List<String>> mapTiles}) {
    this.mapImages = mapImages;
    this.mapTiles = mapTiles;
  }


  void  move(int rows, int columns) {
    List<int> directionValues = direction_table[this.direction];
    int dx;
    int dy;
    dx = directionValues[0];
    dy = directionValues[1];



    //sensing

  var ahead = mapTiles[positionTortoise.y + dy][positionTortoise.x + dx];

    var here = this.mapTiles[positionTortoise.y][positionTortoise.x];
    bool freeAhead = !['stone', 'wall'].contains(ahead);
    bool lettuceAhead = (ahead == 'lettuce');
    bool lettuceHere = (here == 'lettuce');
    bool waterAhead = (ahead == 'pond');
    bool waterHere = (here == 'pond');


    // Sensor sensor = Sensor(
    //   freeAhead: freeAhead,
    //   lettuceAhead: lettuceAhead,
    //   lettuceHere: lettuceHere,
    //   waterAhead: waterAhead,
    //   waterHere: waterHere,
    //   drinkLevel: this.drink_level,
    //   tortoisePosition: [this.xpos, this.ypos],
    //   tortoiseDirection: this.direction,
    // );


    String action = brain.decideMove();
    print(action);
    switch (action) {
      case 'left':
        direction = (direction - 1) % 4;

        break;
      case 'right':
        direction = (direction + 1) % 4;

        break;
      case 'eat':
        print("eat");
        update=false;

        break;
      case 'drink':
        print("drink");
        update=false;

      case 'forward':
        //prbleme exemple ona  tortue en left et on a forward elle se dirige vers le heaut
        update=true;
        print(positionTortoise.x + dx);
        print(positionTortoise.y + dy);
        if (freeAhead) {//prob ici et positon pour froward
          mapTiles[positionTortoise.y][positionTortoise.x]="ground";//a revoir
          mapImages[positionTortoise.y][positionTortoise.x]= 'assets/images/ground.gif';//a revoir cas lettue et ne pas manger
          positionTortoise.x = positionTortoise.x + dx;
          positionTortoise.y = positionTortoise.y + dy;

        }
        else {
          //cond apres
        }
        break;
    }
 //   print('Tortoise moves $action');

  }
}
class Sensor {
  final bool freeAhead;
  final bool lettuceAhead;
  final bool lettuceHere;
  final bool waterAhead;
  final bool waterHere;
  final int drinkLevel;
  final List<int> tortoisePosition;
  final int tortoiseDirection;

  Sensor({
    required this.freeAhead,
    required this.lettuceAhead,
    required this.lettuceHere,
    required this.waterAhead,
    required this.waterHere,
    required this.drinkLevel,
    required this.tortoisePosition,
    required this.tortoiseDirection,
  });
}
