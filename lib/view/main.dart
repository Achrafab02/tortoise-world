import 'package:flutter/material.dart';

import 'main_screen.dart';

void main() {
  runApp(const TortoiseGame());
}

class TortoiseGame extends StatelessWidget {
  const TortoiseGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MainScreen(),
      ),
    );
  }
}
