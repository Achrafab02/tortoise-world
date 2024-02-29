import 'package:flutter/material.dart';
import 'dart:math';

class TortoiseBrain {
  String think(capteur) {
    List<String> actions = ['left', 'right', 'eat', 'drink','forward'];
    Random random = Random();
    return actions[random.nextInt(actions.length)];
  }
}