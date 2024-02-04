import 'Lexer.dart';
import 'Token.dart';
import 'Parser.dart';
class GrammarModel {
  Lexer lexer;

  GrammarModel(this.lexer);

  void parse() {
    var token = <Token>[];
    while (true) {
      token.add(lexer.getNextToken());
      if (token.last.type == TokenType.EOF) {
        break;
      }
    }
    var parser = Parser(token);
    parser.parse();
  }


}