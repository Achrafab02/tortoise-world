// lib/main.dart
import 'package:flutter/material.dart';
import 'game_grid.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tortoise World !'),
        ),
        body: Center(
          child: GameGrid(), // Utilisez GameGrid au lieu de JeuGrid
        ),
      ),
    );
  }
}
