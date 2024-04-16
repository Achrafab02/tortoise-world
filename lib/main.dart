import 'package:flutter/material.dart';

import 'game_view.dart';
import 'green_theme.dart';

void main() {
  runApp(const TortoiseGame());
}

class TortoiseGame extends StatelessWidget {
  const TortoiseGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: GameView(),
      ),
      theme: greenTheme,
    );
  }
}
