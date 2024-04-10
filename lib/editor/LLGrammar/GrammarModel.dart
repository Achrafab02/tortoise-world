import 'Lexer.dart';
import 'Parser.dart';
import 'Token.dart';

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
