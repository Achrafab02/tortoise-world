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
          title: Text('Exemple de 3 fenêtres'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Première ligne avec deux fenêtres
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FenetreWidget('Fenêtre 1'),
                FenetreWidget('Fenêtre 2'),
              ],
            ),

            // Deuxième ligne avec une fenêtre en dessous
            FenetreWidget('Fenêtre 3'),
          ],
        ),
      ),
    );
  }
}

class FenetreWidget extends StatelessWidget {
  final String titre;

  FenetreWidget(this.titre);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Ajustez la largeur selon vos besoins
      height: 150, // Ajustez la hauteur selon vos besoins
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(titre),
      ),
    );
  }
}
