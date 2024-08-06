import 'package:flutter/scheduler.dart';
import 'package:tortoise_world/editor/editor_view.dart';
import 'package:tortoise_world/editor/interpreter.dart';
import 'package:tortoise_world/game/board_view.dart';
import 'package:tortoise_world/game/tortoise_world.dart';

class GamePresenter {
  final Interpreter _codeInterpreter = Interpreter();
  late final Ticker _ticker;
  EditorViewState? _editorViewState;

  final TortoiseWorld tortoiseWorld = TortoiseWorld();

  GamePresenter();

  void setBoard({required Ticker ticker}) {
    _ticker = ticker;
  }

  void dispose() {
    _ticker.dispose();
  }

  void _start(EditorViewState editorViewState) {
    _editorViewState = editorViewState;
    _ticker.start();
  }

  void stop() {
    _ticker.stop();
  }

  void initializeWorldMap() => tortoiseWorld.initializeWorldMap();

  void executeCode(EditorViewState editorViewState, String code) {
    initializeWorldMap();
    String? error = _codeInterpreter.parse(code);
    if (error != null) {
      editorViewState.showErrorDialog(error.replaceFirst('Exception: ', ''));
    } else {
      _start(editorViewState);
    }
  }

  Future<void> update(Duration elapsed, BoardViewState boardViewState) async {
    print("update ...");
    if (tortoiseWorld.moveCount <= TortoiseWorld.maxTime) {
      var action = _codeInterpreter.executeCode(tortoiseWorld);
      MoveResultType result = tortoiseWorld.moveTortoise(action);
      if (result == MoveResultType.diedOfThirsty) {
        _editorViewState?.stopExecution();
        boardViewState.showResultDialog("Vous êtes mort de soif!");
      }
      if (result == MoveResultType.diedOfHunger) {
        _editorViewState?.stopExecution();
        boardViewState.showResultDialog("Vous êtes mort de faim!");
        // TODO Ajouter le niveau de sante
      } else if (result == MoveResultType.success) {
        _editorViewState?.stopExecution();
        boardViewState.showResultDialog("Bravo, vous avez gagné");
      }
    }
  }
}
