import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

void main() async {
  runApp(MyApp());
}

void pythonToDart() async {
  // Chemin vers le script Python
  String pythonScriptPath =
      '/home/achraf/Documents/2A/projet2A/tortoise-world/Tortoise/tortoise.py';

  // Chemin vers le répertoire du script Python
  String pythonScriptDirectory = path.dirname(pythonScriptPath);

  // Ajuste le répertoire de travail
  Directory.current = pythonScriptDirectory;

  // Exécute la commande Python
  ProcessResult result = await Process.run('python', [pythonScriptPath]);

  // Vérifie si l'exécution s'est bien déroulée
  if (result.exitCode == 0) {
    print('Le script Python a été exécuté avec succès.');
  } else {
    print('Erreur lors de l\'exécution du script Python : ${result.stderr}');
  }
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

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Container(
                      width: 200.0,
                      height: 200.0,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5.0),
              Expanded(
                child: Container(
                  color: Colors.blueGrey,
                  child: Center(
                    child: Container(
                      width: 150.0,
                      height: 150.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Appel de la fonction pythonToDart() lors du clic sur le bouton "Start"
                              pythonToDart();
                              print("Start Button Clicked");
                            },
                            child: Text('Start'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print("Clear Button Clicked");
                            },
                            child: Text('Clear'),
                          ),
                          Container(
                            width: 150.0,
                            height: 50.0,
                            color: Colors.white,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Entrez votre code ici',
                                contentPadding: EdgeInsets.all(8.0),
                              ),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.0),
        Expanded(
          child: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Instructions:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  'Ajoutez vos instructions ici.',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
