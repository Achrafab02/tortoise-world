import 'package:tortoise_world/Presenter/LLGrammarPresenter/GrammarPresenter.dart';
import 'package:tortoise_world/Model/LLGrammarModel/GrammarModel.dart';

import '../../Model/LLGrammarModel/Lexer.dart';

class GrammarView {
  GrammarPresenter _presenter;

  GrammarView(this._presenter);

  void parseInput(String input) {
    var lexer = Lexer(input);
    var model = GrammarModel(lexer);
    _presenter = GrammarPresenter(model);
    _presenter.startParsing();
  }
}