import 'package:flutter_test/flutter_test.dart';
import 'package:tortoise_world/editor/grammar/lexer.dart';
import 'package:tortoise_world/editor/grammar/token.dart';

void main() {
  test('Tokenizing input with only return statement', () {
    var lexer = Lexer("return DROITE");
    List<Token> token = lexer.tokenizeCode();
    expect(token[0].type, TokenType.RETURN);
    expect(token[1].type, TokenType.RIGHT);
  });

  test('Tokenizing input with random', () {
    var lexer = Lexer("return random.choice([GAUCHE, DROITE])");
    List<Token> token = lexer.tokenizeCode();
    expect(token[0].type, TokenType.RETURN);
    expect(token[1].type, TokenType.RANDOM);
    expect(token[2].type, TokenType.LPAREN);
    expect(token[3].type, TokenType.LBRACKET);
    expect(token[4].type, TokenType.LEFT);
    expect(token[5].type, TokenType.COMMA);
    expect(token[6].type, TokenType.RIGHT);
    expect(token[7].type, TokenType.RBRACKET);
    expect(token[8].type, TokenType.RPAREN);
    expect(token[9].type, TokenType.EOF);
  });

  test('Tokenizing input with if statement', () {
    var lexer = Lexer("if capteur.libre_devant: return AVANCE");
    List<Token> token = lexer.tokenizeCode();
    expect(token[0].type, TokenType.IF);
    expect(token[1].type, TokenType.FREE_AHEAD);
    expect(token[2].type, TokenType.COLON);
    expect(token[3].type, TokenType.RETURN);
    expect(token[4].type, TokenType.FORWARD);
  });

  test('Tokenizing input with niveau_boisson', () {
    var lexer = Lexer("if capteur.niveau_boisson <= 70: return BOIT");
    List<Token> token = lexer.tokenizeCode();
    expect(token[0].type, TokenType.IF);
    expect(token[1].type, TokenType.DRINK_LEVEL);
    expect(token[2].type, TokenType.LESS_EQUAL);
    expect(token[3].type, TokenType.INTEGER);
    expect(token[4].type, TokenType.COLON);
    expect(token[5].type, TokenType.RETURN);
    expect(token[6].type, TokenType.DRINK);
    expect(token[7].type, TokenType.EOF);
  });

  test('Tokenizing input with and operator', () {
    var lexer = Lexer("if capteur.eau_ici and capteur.niveau_boisson <= 70: return MANGE");
    List<Token> token = lexer.tokenizeCode();
    expect(token[0].type, TokenType.IF);
    expect(token[1].type, TokenType.WATER_HERE);
    expect(token[2].type, TokenType.AND);
    expect(token[3].type, TokenType.DRINK_LEVEL);
    expect(token[4].type, TokenType.LESS_EQUAL);
    expect(token[5].type, TokenType.INTEGER);
    expect(token[6].type, TokenType.COLON);
    expect(token[7].type, TokenType.RETURN);
    expect(token[8].type, TokenType.EAT);
    expect(token[9].type, TokenType.EOF);
  });

  test('Tokenizing input with or operator', () {
    var lexer = Lexer("if capteur.eau_ici OR capteur.niveau_boisson <= 70: return BOIT");
    List<Token> token = lexer.tokenizeCode();
    expect(token[0].type, TokenType.IF);
    expect(token[1].type, TokenType.WATER_HERE);
    expect(token[2].type, TokenType.OR);
    expect(token[3].type, TokenType.DRINK_LEVEL);
    expect(token[4].type, TokenType.LESS_EQUAL);
    expect(token[5].type, TokenType.INTEGER);
    expect(token[6].type, TokenType.COLON);
    expect(token[7].type, TokenType.RETURN);
    expect(token[8].type, TokenType.DRINK);
    expect(token[9].type, TokenType.EOF);
  });

  test('Tokenizing input with parenthesis', () {
    var lexer = Lexer("if (capteur.eau_ici or capteur.niveau_boisson == 70): return BOIT");
    List<Token> token = lexer.tokenizeCode();
    expect(token[0].type, TokenType.IF);
    expect(token[1].type, TokenType.LPAREN);
    expect(token[2].type, TokenType.WATER_HERE);
    expect(token[3].type, TokenType.OR);
    expect(token[4].type, TokenType.DRINK_LEVEL);
    expect(token[5].type, TokenType.EQUAL);
    expect(token[6].type, TokenType.INTEGER);
    expect(token[7].type, TokenType.RPAREN);
    expect(token[8].type, TokenType.COLON);
    expect(token[9].type, TokenType.RETURN);
    expect(token[10].type, TokenType.DRINK);
    expect(token[11].type, TokenType.EOF);
  });

  test('Tokenizing input with all actions', () {
    var lexer = Lexer("AVANCE DROITE GAUCHE MANGE BOIT");
    List<Token> token = lexer.tokenizeCode();
    expect(token[0].type, TokenType.FORWARD);
    expect(token[1].type, TokenType.RIGHT);
    expect(token[2].type, TokenType.LEFT);
    expect(token[3].type, TokenType.EAT);
    expect(token[4].type, TokenType.DRINK);
  });

  test('Tokenizing input with all sensors', () {
    var lexer = Lexer("capteur.eau_devant capteur.eau_ici capteur.libre_devant capteur.laitue_devant capteur.laitue_ici capteur.niveau_boisson");
    List<Token> token = lexer.tokenizeCode();
    expect(token[0].type, TokenType.WATER_AHEAD);
    expect(token[1].type, TokenType.WATER_HERE);
    expect(token[2].type, TokenType.FREE_AHEAD);
    expect(token[3].type, TokenType.LETTUCE_AHEAD);
    expect(token[4].type, TokenType.LETTUCE_HERE);
    expect(token[5].type, TokenType.DRINK_LEVEL);
  });
}
