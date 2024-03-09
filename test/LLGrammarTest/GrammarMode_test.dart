import 'package:flutter_test/flutter_test.dart';
import 'package:tortoise_world/Model/LLGrammarModel/Lexer.dart';
import 'package:tortoise_world/Model/LLGrammarModel/Parser.dart';
import 'package:tortoise_world/Model/LLGrammarModel/Token.dart';
import 'package:tortoise_world/Model/LLGrammarModel/GrammarModel.dart';

//generate rapports JUnit and coverage
void main() {
  group('Lexer Tests', () {
    test('Tokenizing input with if statement', () {
      var lexer =
      Lexer("if capteur.libre_devant: return AVANCE");
      var model = GrammarModel(lexer);
      var token = <Token>[];
      while (true) {
        token.add(model.lexer.getNextToken());
        if (token.last.type == TokenType.EOF) {
          break;
        }
      }
      expect(token[0].type, TokenType.IF);
      expect(token[1].type, TokenType.IDENTIFIER);
      expect(token[2].type, TokenType.DOT);
      expect(token[3].type, TokenType.IDENTIFIER);
      expect(token[4].type, TokenType.COLON);
      expect(token[5].type, TokenType.RETURN);
      expect(token[6].type, TokenType.CONSTANT);
    });

    test('Tokenizing and test lexeme', () {
      var lexer =
      Lexer("if capteur.libre_devant: return AVANCE else : return DROITE");
      var model = GrammarModel(lexer);
      var token = <Token>[];
      while (true) {
        token.add(model.lexer.getNextToken());
        if (token.last.type == TokenType.EOF) {
          break;
        }
      }
      expect(token[0].lexeme, 'if');
      expect(token[1].lexeme, 'capteur');
      expect(token[2].lexeme, '.');
      expect(token[3].lexeme, 'libre_devant');
      expect(token[4].lexeme, ':');
      expect(token[5].lexeme, 'return');
      expect(token[6].lexeme, 'AVANCE');
      expect(token[7].lexeme, 'else');
      expect(token[8].lexeme, ':');
      expect(token[9].lexeme, 'return');
      expect(token[10].lexeme, 'DROITE');
      expect(token[11].lexeme, '');
    });

    test('Tokenizing input with niveau.boisson', () {
      var lexer = Lexer(
          "if capteur.eau_ici and capteur.niveau.boisson <= 70: return BOIT");
      var model = GrammarModel(lexer);
      var token = <Token>[];
      while (true) {
        token.add(model.lexer.getNextToken());
        if (token.last.type == TokenType.EOF) {
          break;
        }
      }
      expect(token[0].type, TokenType.IF);
      expect(token[1].type, TokenType.IDENTIFIER);
      expect(token[2].type, TokenType.DOT);
      expect(token[3].type, TokenType.IDENTIFIER);
      expect(token[4].type, TokenType.AND);
      expect(token[5].type, TokenType.IDENTIFIER);
      expect(token[6].type, TokenType.DOT);
      expect(token[7].type, TokenType.IDENTIFIER);
      expect(token[8].type, TokenType.DOT);
      expect(token[9].type, TokenType.IDENTIFIER);
      expect(token[10].type, TokenType.LESS_EQUAL);
      expect(token[11].type, TokenType.CONSTANT);
      expect(token[12].type, TokenType.COLON);
      expect(token[13].type, TokenType.RETURN);
      expect(token[14].type, TokenType.CONSTANT);
      expect(token[15].type, TokenType.EOF);
    });

    test('Tokenizing input with bracket', () {
      var lexer = Lexer("return random.choise([GAUCE,DROITE])");
      var model = GrammarModel(lexer);
      var token = <Token>[];
      while (true) {
        token.add(model.lexer.getNextToken());
        if (token.last.type == TokenType.EOF) {
          break;
        }
      }
      expect(token[0].type, TokenType.RETURN);
      expect(token[1].type, TokenType.IDENTIFIER);
      expect(token[2].type, TokenType.DOT);
      expect(token[3].type, TokenType.IDENTIFIER);
      expect(token[4].type, TokenType.LPAREN);
      expect(token[5].type, TokenType.LBRACKET);
      expect(token[6].type, TokenType.CONSTANT);
      expect(token[7].type, TokenType.COMMA);
      expect(token[8].type, TokenType.CONSTANT);
      expect(token[9].type, TokenType.RBRACKET);
      expect(token[10].type, TokenType.RPAREN);
      expect(token[11].type, TokenType.EOF);
    });

    test('Tokenizing input with laitue condition and else if condition', () {
      var lexer = Lexer(
          "if capteur.laitue_devant: return AVANCE else if capteur.laitue_ici: return MANGE else : return DROITE");
      var model = GrammarModel(lexer);
      var token = <Token>[];
      while (true) {
        token.add(model.lexer.getNextToken());
        if (token.last.type == TokenType.EOF) {
          break;
        }
      }
      expect(token[0].type, TokenType.IF);
      expect(token[1].type, TokenType.IDENTIFIER);
      expect(token[2].type, TokenType.DOT);
      expect(token[3].type, TokenType.IDENTIFIER);
      expect(token[4].type, TokenType.COLON);
      expect(token[5].type, TokenType.RETURN);
      expect(token[6].type, TokenType.CONSTANT);
      expect(token[7].type, TokenType.ELSE);
      expect(token[8].type, TokenType.IF);
      expect(token[9].type, TokenType.IDENTIFIER);
      expect(token[10].type, TokenType.DOT);
      expect(token[11].type, TokenType.IDENTIFIER);
      expect(token[12].type, TokenType.COLON);
      expect(token[13].type, TokenType.RETURN);
      expect(token[14].type, TokenType.CONSTANT);
      expect(token[15].type, TokenType.ELSE);
      expect(token[16].type, TokenType.COLON);
      expect(token[17].type, TokenType.RETURN);
      expect(token[18].type, TokenType.CONSTANT);
      expect(token[19].type, TokenType.EOF);
    });
  });

  group('Parser Tests', () {
    test('Parsing input with if statement', () {
      var lexer =
      Lexer("if capteur.libre_devant: return FORWARD");
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
      expect(parser.sensors['libre_devant'], true);
      expect(parser.sensors['laitue_devant'], false);
      expect(parser.result[0], 'FORWARD');
    });

    test('Parsing input with only return statement', () {
      var lexer = Lexer("return RIGHT");
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
      expect(parser.result[0], 'RIGHT');
    });

test('Parsing input with if statement and else statement', () {
      var lexer = Lexer("if capteur.libre_devant: return AVANCE else : return DROITE");
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
      expect(parser.sensors['libre_devant'], true);
      expect(parser.result[0], 'AVANCE');
      expect(parser.result[1], 'DROITE');
    });

    test('Parsing input with laitue condition and else if condition', () {
      var lexer = Lexer(
          "if capteur.laitue_devant: return AVANCE else if capteur.laitue_ici: return MANGE else : return DROITE");
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

    test('Parsing input with niveau.boisson', () {
      var lexer = Lexer(
          "if capteur.eau_ici and capteur.niveau.boisson <= 70: return BOIT");
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

    test('Parsing input with random.choise', () {
      var lexer = Lexer("return random.choise([GAUCE,DROITE])");
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

    test('Parsing input with random.choise', () {
      var lexer = Lexer("return random.choise([AVAVCE,DROITE,GAUCE])");
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
