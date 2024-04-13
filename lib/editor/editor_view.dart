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
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      language: python,
      params: const EditorParams(tabSpaces: 8),
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
        ElevatedButton(
          onPressed: () async {
            if (_isRunning) {
              stopExecution();
            } else {
              _startExecution();
            }
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(150, 30),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueGrey,
          ),
          child: _isRunning ? const Text("Stop") : const Text("Exécuter"),
        ),
      ],
    );
  }

  void _startExecution() {
    if (_codeController != null) {
      setState(() {
        widget.gamePresenter.executeCode(this, _codeController.text);
        _isRunning = true;
      });
    }
  }

  void stopExecution() {
    setState(() {
      _isRunning = false;
      widget.gamePresenter.stop();
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Correction de code'),
          content: Text('Vous devez corriger votre code : $message'),
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
}
