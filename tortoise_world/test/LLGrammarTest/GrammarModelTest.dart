import 'package:flutter_test/flutter_test.dart';
import 'package:tortoise_world/Model/LLGrammarModel/Lexer.dart';
import 'package:tortoise_world/Model/LLGrammarModel/Parser.dart';
import 'package:tortoise_world/Model/LLGrammarModel/Token.dart';
import 'package:tortoise_world/Model/LLGrammarModel/GrammarModel.dart';



void main() {
  group('Lexer Tests', () {
    test('Tokenizing input with if statement', ()
    {
      var lexer = Lexer("if capteur.libre_devant: return AVANCE else: return DROITE");
      GrammarModel model = GrammarModel(lexer);
      Token token = model.lexer.getNextToken();
      expect(token.type, TokenType.IF);
      expect(token.lexeme, 'if');
    });
  });

  group('Parser Tests', () {
    test('Parsing input with if statement', ()
    {
      var lexer = Lexer("if capteur.libre_devant: return AVANCE else: return DROITE");
      var model = GrammarModel(lexer);
      var token = <Token>[];
      while (true) {
        token.add(model.lexer.getNextToken());
        if (token.last.type == TokenType.EOF) {
          break;
        }
      }
      var parser = Parser(token);
      parser.parse();
    });
  });
}



