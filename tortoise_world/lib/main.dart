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
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey,
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
                  color: Colors.grey,
                  child: Center(
                    child: Container(
                      width: 500.0,
                      height: 200.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 500.0,
                            height: 100.0,
                            color: Colors.grey,
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(

                                hintText: 'Entrez votre code ici',
                                contentPadding: EdgeInsets.all(8.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                //couleur de la bordure quand on clique sur le champ
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              maxLines: 10,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Appel de la fonction pythonToDart() lors du clic sur le bouton "Start"
                              String text = _controller.text;
                              String defaultText = "#! /usr/bin/python -*- coding: utf-8 -*-\n\nfrom agents import *\n\ndef think(capteur):\n\treturn ";
                              String finalText = defaultText + text;
                              File file = File('/home/achraf/Documents/2A/projet2A/tortoise-world/Tortoise/matortue.py');
                              await file.writeAsString(finalText);
                              pythonToDart();
                              print("Start Button Clicked");
                            },
                            child: Text('Start'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green), // Couleur de fond
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Couleur du texte
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>( // Forme du bouton
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.green)
                                )
                              )
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print("Clear Button Clicked");
                              _controller.clear();
                            },
                            child: Text('Clear'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Couleur de fond
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Couleur du texte
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>( // Forme du bouton
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red)
                                )
                              )
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
            color: Colors.grey,
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
