import 'package:flutter/material.dart';
import 'package:tortoise_world/presenter/LLGrammarPresenter/GrammarPresenter.dart';

import 'editor.dart';
import 'game_board.dart';
import 'start_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<MainScreen> {
  String code = '';
  bool isCodeExecuted = false;
  final GrammarPresenter presenter = GrammarPresenter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Tortoise World',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => StartPage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Instructions du jeu'),
                    content: const Text(
                      'Bienvenue dans le monde de la tortue! \n'
                      '- Pour faire avancer la tortue, il faut que la case devant elle soit libre. on verifie cette condition avec le code suivant: \n'
                      'if capteur.libre_devant : return AVANCE\n'
                      '- Pour faire manger la tortue. on execute le code suivant: \n'
                      'if capteur.laitue_ici : return MANGE\n'
                      '- Pour faire boire la tortue, on execute le code suivant: \n'
                      'if capteur.eau_ici : return BOIT\n'
                      '- Pour faire tourner la tortue a gauche, on execute le code suivant: \n'
                      'return GAUCHE\n'
                      '- Pour faire tourner la tortue a droite, on execute le code suivant: \n'
                      'return DROITE\n'
                      '- Si vous hesitez, vous pouvez utiliser l\'aleatoire pour faire bouger la tortue, pour cela, vous pouvez utiliser le code suivant: \n'
                      'return random([GAUCHE, DROITE, AVANCE, MANGE, BOIT])\n'
                      'Bonne chance!',
                      style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'Roboto'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Fermer'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF7697A0), Color(0xFFDDDDDA)],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(20.0),
                child: GameScreen(presenter),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(20.0),
                child: Editor(presenter),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
