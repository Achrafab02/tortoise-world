import '../../model/LLGrammarModel/GrammarModel.dart';
import '../../model/LLGrammarModel/Parser.dart';
import '../../model/LLGrammarModel/Token.dart';
import '../../model/model.dart';

class GrammarPresenter {

  Tortoise tortoise = Tortoise(worldMap: []);

  TortoiseBrain tortoiseBrain = TortoiseBrain();

  void setParser(Parser parser) {
    tortoiseBrain.setParser(parser);
  }
}