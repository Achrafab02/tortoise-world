import 'package:flutter/material.dart';

import 'editor/editor_view.dart';
import 'game/board_view.dart';
import 'game_presenter.dart';
import 'integer_picker_widget.dart';

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
          'Le monde de la tortue \u00a9 ENSICAEN 2024',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IntegerPickerWidget(
            title: "Taille de la grille",
            minValue: 6,
            maxValue: 20,
            initialValue: _gamePresenter.gridSize,
            onChanged: (value) => _gamePresenter.gridSize = value,
          ),
          const SizedBox(width: 100),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Liste des instructions'),
                    content: const Text(
                      "Exemples de programme :\n"
                      "  if capteur.libre_devant: return AVANCE\n"
                      "  if capteur.niveau_boisson < 20 and capteur.libre_devant: return AVANCE\n"
                      "\nListe des valeurs du capteur :\n"
                      "  - capteur.libre_devant\n"
                      "  - capteur.laitue_ici\n"
                      "  - capteur.laitue_devant\n"
                      "  - capteur.eau_devant\n"
                      "  - capteur.eau_ici\n"
                      "  - capteur.niveau_boisson\n"
                      "\nListe des commandes possibles :\n"
                      "  - return GAUCHE\n"
                      "  - return DROITE\n"
                      "  - return AVANCE\n"
                      "  - return MANGE\n"
                      "  - return BOIT\n"
                      "\nChoisir une action au hasard :\n"
                      '  return random.choice([GAUCHE, DROITE, AVANCE, MANGE, BOIT])\n',
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
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
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
    );
  }
}
