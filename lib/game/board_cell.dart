import 'package:flutter/material.dart';

class BoardCell extends StatelessWidget {
  final String imageName;
  final String tortoiseImage;
  final bool isTortoisePosition;

  const BoardCell({
    super.key,
    required this.imageName,
    required this.tortoiseImage,
    required this.isTortoisePosition,
  });

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
            Image.asset('assets/images/ground.gif'),
            Image.asset('assets/images/$imageName.gif'),
            if (isTortoisePosition) Image.asset('assets/images/$tortoiseImage.gif'),
          ],
        ),
      ),
    );
  }
}
