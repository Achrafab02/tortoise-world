import 'package:flutter/material.dart';
import 'package:tortoise_world/Model/LLGrammarModel/Parser.dart';
import 'dart:math';
import '';

import 'package:tortoise_world/Model/model.dart';

class TortoiseBrain {
  String think({required Sensor sensor}) {
    return 'FORWARD';
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