import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/python.dart';
import 'package:tortoise_world/game_presenter.dart';

// TODO ajouter au-dessus de l'éditeur les instructions utiles (AVANCE et capteur.laiture_devant...)
// TODO Utiliser le même bouton pour executer et pour stopper l'exécution.
// TODO Ajouter l'analyse interactive du code et afficher les erreurs en soulignant l'endroit de l'erreur (puis tooltip avce le détail de l'erreur)
class EditorView extends StatefulWidget {
  final GamePresenter gamePresenter;

  const EditorView(this.gamePresenter, {super.key});

  @override
  EditorViewState createState() => EditorViewState();
}

class EditorViewState extends State<EditorView> {
  late final CodeController? _codeController;
  bool isCodeExecuted = false;

  @override
  void initState() {
    super.initState();
    // Instantiate the CodeController
    _codeController = CodeController(
      text: "",
      language: python,
    );
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

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
        Expanded(
          child: CodeTheme(
            data: const CodeThemeData(styles: monokaiSublimeTheme),
            child: CodeField(
              controller: _codeController!,
              textStyle: const TextStyle(fontFamily: 'SourceCode', fontSize: 24),
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // TODO faire un seul bouton pour Execute et Stop
                child: ElevatedButton(
                  onPressed: () async {
                    widget.gamePresenter.setCode(_codeController.text);
                    widget.gamePresenter.executeCode(this);
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
                  ),
                  child: const Text('Stop'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void showErrorDialog(String message) {
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

  void _stopCodeExecution() {
    setState(() {
      isCodeExecuted = false;
      widget.gamePresenter.stop();
    });
  }
}
