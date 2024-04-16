import 'package:flutter_test/flutter_test.dart';
import 'package:tortoise_world/editor/grammar/lexer.dart';
import 'package:tortoise_world/editor/grammar/parser.dart';
import 'package:tortoise_world/editor/grammar/token.dart';

void main() {
  test('test isAction false', () {
    expect(Parser.isAction(TokenType.DRINK_LEVEL), false);
  });

  test('test isAction true', () {
    expect(Parser.isAction(TokenType.FORWARD), true);
  });

  test('Parsing input with only return statement', () {
    var lexer = Lexer("return DROITE");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    expect(() => parser.parse(), returnsNormally);
  });

  test('Parsing input with random.choice with 1 item', () {
    var lexer = Lexer("return random.choice([GAUCHE])");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    expect(() => parser.parse(), returnsNormally);
  });

  test('Parsing input with random.choice with 3 items', () {
    var lexer = Lexer("return random.choice([AVANCE, DROITE,GAUCHE])");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    expect(() => parser.parse(), returnsNormally);
  });

  test('Parsing input with if statement', () {
    var lexer = Lexer("if capteur.libre_devant : return AVANCE");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    expect(() => parser.parse(), returnsNormally);
  });

  test('Parsing input with niveau boisson', () {
    var lexer = Lexer("if capteur.niveau_boisson < 70: return BOIT");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    expect(() => parser.parse(), returnsNormally);
  });

  test('Parsing input with not', () {
    var lexer = Lexer("if not capteur.eau_ici: return AVANCE");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    expect(() => parser.parse(), returnsNormally);
  });

  test('Parsing input with and', () {
    var lexer = Lexer("if capteur.eau_ici and capteur.niveau_boisson <= 70: return BOIT");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    expect(() => parser.parse(), returnsNormally);
  });

  test('Parsing input with 2 and', () {
    var lexer = Lexer("if capteur.eau_ici and capteur.libre_devant and capteur.niveau_boisson <= 70: return BOIT");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    expect(() => parser.parse(), returnsNormally);
  });

  test('Parsing input with parenthesis', () {
    var lexer = Lexer("if (capteur.eau_ici and capteur.niveau_boisson <= 70): return BOIT");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    expect(() => parser.parse(), returnsNormally);
  });
}
