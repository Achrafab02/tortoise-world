import 'package:flutter_test/flutter_test.dart';
import 'package:tortoise_world/editor/grammar/lexer.dart';
import 'package:tortoise_world/editor/grammar/parser.dart';
import 'package:tortoise_world/editor/grammar/token.dart';

//generate rapports JUnit and coverage
void main() {
  test('Parsing input with if statement', () {
    var lexer = Lexer("if capteur.libre_devant : return AVANCE");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    parser.parse();
    // expect();
  });

  test('Parsing input with only return statement', () {
    var lexer = Lexer("return DROITE");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    parser.parse();
  });

  test('Parsing input with if statement and else statement', () {
    var lexer = Lexer("if capteur.libre_devant: return AVANCE else : return random.choise([GAUCHE,DROITE])");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    parser.parse();
  });

  test('Parsing input with laitue condition and else if condition', () {
    var lexer = Lexer("if capteur.laitue_devant: return AVANCE else if capteur.laitue_ici: return MANGE else : return DROITE");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    parser.parse();
  });

  test('Parsing input with niveau.boisson', () {
    var lexer = Lexer("if capteur.eau_ici and capteur.niveau.boisson <= 70: return BOIT");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    parser.parse();
  });

  test('Parsing input with random.choise', () {
    var lexer = Lexer("return random.choise([GAUCHE,DROITE])");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    parser.parse();
  });

  test('Parsing input with random.choise', () {
    var lexer = Lexer("return random.choise([AVAVCE,DROITE,GAUCE])");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    parser.parse();
  });
}
