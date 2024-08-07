import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/magula.dart';
import 'package:highlight/languages/python.dart';
import 'package:tortoise_world/game_presenter.dart';

class EditorView extends StatefulWidget {
  final GamePresenter _gamePresenter;

  const EditorView(this._gamePresenter, {super.key});

  @override
  EditorViewState createState() => EditorViewState();
}

class EditorViewState extends State<EditorView> {
  late final CodeController _codeController;
  late FocusNode _focusNode;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      language: python,
      params: const EditorParams(tabSpaces: 8),
    );
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Éditeur de Code",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20.0),
        Expanded(
          child: CodeTheme(
            data: const CodeThemeData(styles: magulaTheme),
            child: CodeField(
              expands: true,
              focusNode: _focusNode,
              controller: _codeController,
              textStyle: const TextStyle(fontFamily: 'SourceCode', fontSize: 18),
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
          child: _isRunning ? const Text("Stop") : const Text("Exécuter"),
        ),
      ],
    );
  }

  void _startExecution() {
    if (_codeController.text.trim().isNotEmpty) {
      setState(() {
        _isRunning = true;
        widget._gamePresenter.executeCode(this, _codeController.text);
      });
    } else {
      showErrorDialog("Ecrivez le programme avant de l'exécuter !");
    }
  }

  void stopExecution() {
    setState(() {
      _isRunning = false;
      widget._gamePresenter.stop();
    });
  }

  void showErrorDialog(String message) {
    stopExecution();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur de compilation', style: TextStyle(color: Colors.red)),
          content: Text(message, style: const TextStyle(color: Colors.black),),
          actions: <Widget>[
            TextButton(
              autofocus: true,
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
