import 'dart:js_util';

import 'package:flutter/material.dart';
import 'dart:math';

import '../utils.dart';
import 'agent.dart';

class Tortoise {
  bool update_current_place = false;
  int direction=0;
  List<List<int>> directionTable = [
    [0, -1],
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, 0],
  ];
  int xpos=1;
  int ypos=1;
  List<List<String>> worldMap = [];
  TortoiseBrain brain = TortoiseBrain();
   late String tortoiseImage;
  List<String> directionTortoiseImageTable = ['tortoise-n', 'tortoise-e', 'tortoise-s', 'tortoise-w'];
  int drinkLevel=MAX_DRINK;
  int health=MAX_HEALTH;
  bool pain=false;
  int eaten=0;
  late int lettuceCount;
  int score=0;
  bool win=false;
  double currentTime=0.0;
  double nextTortoiseTime=0;
  String action='none';

  Tortoise({required List<List<String>> worldMap}) {
    this.worldMap = worldMap;
  }

  void move(){
    currentTime+=0.1;
    if (currentTime>=nextTortoiseTime &&currentTime <=MAX_TIME){
      moveTortoise();


    }

  }
  void updateLettuceCount(int count) {
    lettuceCount = count;
  }

  void moveTortoise() {
    currentTime = nextTortoiseTime;
    int timeChange = 4 - (3 * drinkLevel ~/ MAX_DRINK);
    nextTortoiseTime = currentTime + timeChange;

    List<int> directionXY= directionTable[direction];
    int dx = directionXY[0];
    int dy = directionXY[1];

    String ahead =worldMap[ypos + dy][xpos + dx];
    String here = worldMap[ypos][xpos];
    bool freeAhead = !['stone', 'wall'].contains(ahead);
    bool lettuceAhead = ahead == 'lettuce';
    bool lettuceHere = here == 'lettuce';
    bool waterAhead = ahead == 'pond';
    bool waterHere = here == 'pond';

    action = brain.think();
    print(action);
    switch (action) {
      case 'left':
        direction = (direction - 1) % 4;
        drinkLevel=max(drinkLevel-1, 0);


        break;
      case 'right':
        direction = (direction + 1) % 4;
        drinkLevel=max(drinkLevel-1, 0);


        break;
      case 'eat':
        if (lettuceHere) {
          print("eat");
          worldMap[ypos][xpos] = 'ground';
          eaten=eaten+1;
        }
        break;
      case 'drink':
        if (waterHere) {
          print("drink");
          drinkLevel = MAX_DRINK;
        }
        break;

      case 'forward':
        if (freeAhead) {
          xpos = xpos + dx;
          ypos = ypos + dy;

        }
        else {
          health=health-1;
          pain=true;
          drinkLevel=max(drinkLevel-2, 0);
        }
        break;

    }
    tortoiseImage = directionTortoiseImageTable[direction];
    if(eaten==lettuceCount){
      print("you win");
      action="stop";
      win=true;

    }
    else if (drinkLevel<=0 || health<=0){
      win =false;
      if (drinkLevel<=0){
        print("you died of thirst");
      }
      else{
        print("you died of ill health");

      }
      action="stop";
      pain =true;

    }
    int score = eaten * 10 - (currentTime / 10).toInt();
  }





}