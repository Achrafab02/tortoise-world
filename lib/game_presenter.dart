import 'package:flutter/scheduler.dart';
import 'package:tortoise_world/editor/LLGrammar/Parser.dart';
import 'package:tortoise_world/editor/LLGrammar/code_interpreter.dart';
import 'package:tortoise_world/editor/editor_view.dart';
import 'package:tortoise_world/game/board_view.dart';
import 'package:tortoise_world/game/tortoise_world.dart';

class GamePresenter {
  final TortoiseBrain tortoiseBrain = TortoiseBrain();
  final CodeInterpreter _codeInterpreter = CodeInterpreter();
  late final Ticker _ticker;
  final TortoiseWorld tortoiseWorld = TortoiseWorld();
  double _cumulativeTime = 0;

  GamePresenter();

  void setBoard({required Ticker ticker}) {
    _ticker = ticker;
  }

  void dispose() {
    _ticker.dispose();
  }

  void start() {
    _ticker.start();
  }

  void stop() {
    _ticker.stop();
  }

  void initializeWorldMap() => tortoiseWorld.initializeWorldMap();

  void setCode(String code) {
    _codeInterpreter.setCode(code);
  }

  void executeCode(EditorViewState editorViewState) {
    Parser parser = _codeInterpreter.getParser();
    tortoiseBrain.setParser(parser);
    String? error = _codeInterpreter.parse(parser);
    if (error != null) {
      editorViewState.showErrorDialog(error.replaceFirst('Exception: ', ''));
    } else {
      start();
    }
  }

  void update(Duration elapsed, BoardViewState boardViewState) {
    _cumulativeTime += 1500;
    if (_cumulativeTime > DELAY_IN_MS && tortoiseWorld.moveCount <= MAX_TIME && tortoiseWorld.action != "stop") {
      _cumulativeTime = 0;
      if (tortoiseBrain.parser == null) {
        return;
      }
      MoveResultType result = tortoiseWorld.moveTortoise(_codeInterpreter.executeCode(tortoiseBrain.parser!.resultMap.data, tortoiseWorld));
      if (result == MoveResultType.diedOfThirsty) {
        stop();
        boardViewState.showResultDialog("Vous êtes mort de soif!");
      }

      if (result == MoveResultType.diedOfHunger) {
        stop();
        // TODO Ajouter le niveau de sante
        boardViewState.showResultDialog("Vous êtes mort de faim!");
      }
    }
  }
}
