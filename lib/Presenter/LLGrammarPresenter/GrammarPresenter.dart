import '../../Model/LLGrammarModel/GrammarModel.dart';
import '../../Model/LLGrammarModel/Parser.dart';
import '../../Model/LLGrammarModel/Token.dart';
import '../../Model/agent.dart';
import '../../Model/model.dart';

class GrammarPresenter {

  Tortoise tortoise = Tortoise(worldMap: []);

  TortoiseBrain tortoiseBrain = TortoiseBrain();

  void setParser(Parser parser) {
    tortoiseBrain.setParser(parser);
  }
}