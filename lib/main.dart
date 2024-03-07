// main.dart

import 'package:flutter/material.dart';
import 'grid_generator.dart'; // Importation de grid_generator.dart

void main() {
  runApp(SplitWindowApp());
}

class SplitWindowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fenêtre divisée'),
        ),
        body: SplitScreen(),
      ),
    );
  }
}

class SplitScreen extends StatefulWidget {
  @override
  _SplitScreenState createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> {
  String code = '';
  List<List<String>> grid = []; // Utiliser une liste pour stocker la grille

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          // Partie gauche de la fenêtre
          child: Container(
            color: Colors.blueGrey[100],
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Éditeur de Code',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      code = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Écrivez votre code ici',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                  maxLines: 10,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Exécuter le code et mettre à jour la grille
                    setState(() {
                      runApp(GameApp());
                    });
                  },
                  child: Text('Exécuter'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          // Partie droite de la fenêtre
          child: Container(
            color: Colors.lightGreen[100],
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 12, // Modifier selon la taille de votre grille
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: grid.length * grid.length,
                itemBuilder: (context, index) {
                  int row = index ~/ grid.length;
                  int col = index % grid.length;
                  return Container(
                    color: _getColor(grid[row][col]), // Obtenir la couleur de la cellule
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Fonction pour obtenir la couleur en fonction du type de cellule
  Color _getColor(String cellType) {
    switch (cellType) {
      case 'lettuce':
        return Colors.green[200]!;
      case 'stone':
        return Colors.grey[400]!;
      case 'pond':
        return Colors.blue[200]!;
      default:
        return Colors.white;
    }
  }
}
