import 'package:flutter/material.dart';
import 'dart:math';

class TortoiseBrain {
  String think() {
    List<String> actions = ['left', 'right', 'eat', 'drink','forward','forward','forward'];
    Random random = Random();
    return actions[random.nextInt(actions.length)];
  }
}