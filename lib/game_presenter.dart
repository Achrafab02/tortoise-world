import 'dart:async';

import 'package:tortoise_world/editor/editor_view.dart';
import 'package:tortoise_world/editor/interpreter.dart';
import 'package:tortoise_world/game/board_view.dart';
import 'package:tortoise_world/game/tortoise_world.dart';

class GamePresenter {
  final Interpreter _codeInterpreter = Interpreter();
  Timer? _timer;
  EditorViewState? _editorViewState;

  final TortoiseWorld tortoiseWorld = TortoiseWorld();
  late final BoardViewState _boardViewState;

  GamePresenter();

  void setBoardView(BoardViewState boardViewState) {
    _boardViewState = boardViewState;
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  void _start(EditorViewState editorViewState) {
    _editorViewState = editorViewState;
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(milliseconds: 200), (Timer timer) async {
      await update();
      _boardViewState.update();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
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

  Future<void> update() async {
    if (tortoiseWorld.moveCount <= TortoiseWorld.maxTime) {
      var action = _codeInterpreter.executeCode(tortoiseWorld);
      MoveResultType result = tortoiseWorld.moveTortoise(action);
      if (result == MoveResultType.diedOfThirsty) {
        _editorViewState?.stopExecution();
        stop();
        _boardViewState.showResultDialog("Vous êtes mort de soif !");
      }
      if (result == MoveResultType.diedOfHunger) {
        _editorViewState?.stopExecution();
        stop();
        _boardViewState.showResultDialog("Vous êtes mort de faim !");
      } else if (result == MoveResultType.success) {
        _editorViewState?.stopExecution();
        stop();
        _boardViewState.showResultDialog("Bravo, vous avez gagné !");
      }
    }
  }
}
