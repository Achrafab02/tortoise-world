import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tortoise_world/Model/model.dart';

class TortoiseBrain {
  String think({required Sensor sensor}) {
    List<String> actions = ['LEFT', 'RIGHT', 'EAT', 'DRINK','FORWARD','FORWARD','FORWARD'];
    Random random = Random();
    return actions[random.nextInt(actions.length)];
  }
}

/*
    if (sensor.laitue_devant) {
      return 'FORWARD';
    } else if (sensor.libre_devant) {
      return 'FORWARD';
    } else if (sensor.laitue_ici) {
      return 'EAT';
    } else if (sensor.eau_devant) {
      return 'FORWARD';
    } else if (sensor.laitue_ici   ) {
      return 'EAT';

    } else {
      return 'LEFT';
    }
     */