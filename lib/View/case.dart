import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tortoise_world/Model/model.dart';
import '../utils.dart';


class CaseImage extends StatelessWidget {
  final String imageName;
  String tortoiseImage;
  bool isTortoisePosition;

  CaseImage(
      {required this.imageName,
      required this.tortoiseImage,
      required this.isTortoisePosition});

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
            if (isTortoisePosition) Image.asset(tortoiseImage)
          ],
        ),
      ),
    );
  }
}
