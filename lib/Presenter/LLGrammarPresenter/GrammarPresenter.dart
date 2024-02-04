import '../../Model/LLGrammarModel/GrammarModel.dart';

class GrammarPresenter {
  final GrammarModel _model;

  GrammarPresenter(this._model);

  void startParsing() {
    _model.parse();
  }
}