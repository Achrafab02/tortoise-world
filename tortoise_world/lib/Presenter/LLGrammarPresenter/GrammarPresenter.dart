import 'package:tortoise_world/Model/LLGrammarModel/Token.dart';
import 'package:tortoise_world/Model/LLGrammarModel/GrammarModel.dart';

class GrammarPresenter {
  final GrammarModel _model;

  GrammarPresenter(this._model);

  void startParsing() {
    while (true) {
      var token = _model.lexer.getNextToken();
      print('${token.type} : ${token.lexeme}');
      if (token.type == TokenType.EOF) {
        break;
      }
    }
  }
}