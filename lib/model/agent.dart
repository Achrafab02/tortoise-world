import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tortoise_world/model/model.dart';

class TortoiseBrain {
  String think({required Sensor sensor}) {
    List<String> actions = ['left', 'right', 'eat', 'drink','forward','forward','forward'];
    Random random = Random();
    return actions[random.nextInt(actions.length)];
  }
}