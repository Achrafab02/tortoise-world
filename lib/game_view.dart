import 'package:flutter/material.dart';

import 'editor/editor_view.dart';
import 'game/board_view.dart';
import 'game_presenter.dart';

class GameView extends StatefulWidget {

  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final GamePresenter _gamePresenter = GamePresenter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Le monde de la tortue',
          style: TextStyle(fontWeight: FontWeight.bold),
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
            colors: [Color(0xFF76A097), Color(0xFFDDDADD)],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(20.0),
                child: BoardView(_gamePresenter),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(20.0),
                child: EditorView(_gamePresenter),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
