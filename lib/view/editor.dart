import 'package:flutter/material.dart';
import 'package:tortoise_world/model/model.dart';
import 'package:tortoise_world/presenter/LLGrammarPresenter/GrammarPresenter.dart';

import '../model/LLGrammarModel/GrammarModel.dart';
import '../model/LLGrammarModel/Lexer.dart';
import '../model/LLGrammarModel/Parser.dart';
import '../model/LLGrammarModel/Token.dart';

// TODO ajouter au-dessus de l'éditeur les instructions utiles
// TODO Utiliser le même bouton pour executer et pour stopper l'exécution.
// TODO autoriser tab dans l'éditeur
// TODO Ajouter l'analyse du code en direct et afficher les erreurs en soulignant l'endroit de l'erreur (puis tooltip)
// TODO mettre de la couleur
class Editor extends StatefulWidget {
  final GrammarPresenter presenter;

  const Editor(this.presenter, {super.key});

  @override
  EditorState createState() => EditorState();
}

class EditorState extends State<Editor> {
  String code = '';
  bool isCodeExecuted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Éditeur de Code',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20.0),
        TextField(
          onChanged: (value) {
            setState(() {
              code = value;
            });
          },
          style: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'Courier New',
          ),
          decoration: const InputDecoration(
            hintText: 'Écrivez votre code ici',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(10.0),
          ),
          maxLines: 10,
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    code = code.replaceAll('random', 'random.choise');
                    var lexer = Lexer(code);
                    var model = GrammarModel(lexer);
                    var token = <Token>[];
                    while (true) {
                      token.add(model.lexer.getNextToken());
                      if (token.last.type == TokenType.EOF) {
                        break;
                      }
                    }
                    var parser = Parser(token);
                    bool hasError = false;
                    try {
                      parser.parse();
                      widget.presenter.setParser(parser);
                    } catch (e) {
                      showErrorDialog(context, e.toString().replaceFirst('Exception: ', ''));
                      hasError = true;
                    }
                    if (!hasError) {
                      widget.presenter.tortoise = Tortoise(worldMap: widget.presenter.tortoise.worldMap);
                      // Exécuter le code et mettre à jour la grille
                      setState(() {
                        isCodeExecuted = true;
                      });
                    }
                    parser.parse();
                    widget.presenter.setParser(parser);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueGrey,
                  ),
                  child: const Text('Exécuter'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _stopCodeExecution,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueGrey,
                  ), // Appeler la fonction d'arrêt
                  child: const Text('Stop'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Fonction pour arrêter l'exécution du code
  void _stopCodeExecution() {
    setState(() {
      isCodeExecuted = false;
    });
  }
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Correction de code'),
        content: Text('Vous devez corriger votre code: $message'),
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
}
