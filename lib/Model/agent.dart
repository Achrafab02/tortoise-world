import 'package:flutter/material.dart';
import 'package:tortoise_world/Model/LLGrammarModel/Parser.dart';
import 'dart:math';
import '';


import 'package:tortoise_world/Model/model.dart';

import 'LLGrammarModel/Token.dart';



class TortoiseBrain {
  late Parser parser;


  String think({required Sensor sensor}) {
    return parser.result;
  }

}
