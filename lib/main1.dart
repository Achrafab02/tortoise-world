import 'package:flutter/material.dart';
import 'main.dart'; // Importation de grid_generator.dart

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
  bool isCodeExecuted = false;

  // Fonction pour arrêter l'exécution du code
  void _stopCodeExecution() {
    setState(() {
      isCodeExecuted = false;
    });
  }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Exécuter le code et mettre à jour la grille
                        setState(() {
                          isCodeExecuted = true;
                        });
                      },
                      child: Text('Exécuter'),
                      style: ElevatedButton.styleFrom(
                        padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _stopCodeExecution, // Appeler la fonction d'arrêt
                      child: Text('Stop'),
                      style: ElevatedButton.styleFrom(
                        padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      ),
                    ),
                  ],
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
              child: isCodeExecuted ? GameScreen() : Container(),
            ),
          ),
        ),
      ],
    );
  }
}