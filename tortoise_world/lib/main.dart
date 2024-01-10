import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tortoise World'),
        ),
        body: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 150.0,
                height: 150.0,
                color: Colors.blue,
                // Widget 1
              ),
            ),
            SizedBox(width: 5.0), // Espacement entre les colonnes
            Center(
              child: Container(
                width: 150.0,
                height: 150.0,
                color: Colors.green,
                // Widget 2
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0), // Espacement entre les lignes
        Center(
          child: Container(
            width: 305.0,
            height: 150.0,
            color: Colors.red,
            // Widget 3
          ),
        ),
      ],
    );
  }
}
