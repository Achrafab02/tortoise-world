import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortoise_world/editor/grammar/lexer.dart';
import 'package:tortoise_world/editor/grammar/parser.dart';
import 'package:tortoise_world/editor/grammar/token.dart';
import 'package:tortoise_world/game/tortoise_world.dart';

class TortoiseWorldMock extends Mock implements TortoiseWorld {}

void main() {
  test('Execute input with only return action statement', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    var lexer = Lexer("return DROITE");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String action = program.interpret(tortoiseWorld);
    expect(action, "DROITE");
  });

  test('Execute input with return random choice statement', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    var lexer = Lexer("return random.choice([AVANCE, AVANCE])");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String action = program.interpret(tortoiseWorld);
    expect(action, "AVANCE");
  });

  test('Execute input with condition true', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    when(() => tortoiseWorld.isLettuceHere()).thenReturn(true);
    var lexer = Lexer("if capteur.laitue_ici: return MANGE");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String action = program.interpret(tortoiseWorld);
    expect(action, "MANGE");
  });

  test('Execute input with condition false', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    when(() => tortoiseWorld.isLettuceHere()).thenReturn(false);
    var lexer = Lexer("if capteur.laitue_ici: return MANGE");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String? action = program.interpret(tortoiseWorld);
    expect(action, null);
  });

  test('Execute input with relational condition true', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    when(() => tortoiseWorld.drinkLevel).thenReturn(40);
    var lexer = Lexer("if capteur.niveau_boisson < 70: return BOIT");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String action = program.interpret(tortoiseWorld);
    expect(action, "BOIT");
  });

  test('Execute input with relational condition false', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    when(() => tortoiseWorld.drinkLevel).thenReturn(100);
    var lexer = Lexer("if capteur.niveau_boisson < 70: return BOIT");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String? action = program.interpret(tortoiseWorld);
    expect(action, null);
  });

  test('Execute input with 2 conditions true', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    when(() => tortoiseWorld.drinkLevel).thenReturn(40);
    when(() => tortoiseWorld.isWaterHere()).thenReturn(true);
    var lexer = Lexer("if (capteur.eau_ici and capteur.niveau_boisson < 70): return BOIT");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String action = program.interpret(tortoiseWorld);
    expect(action, "BOIT");
  });

  test('Execute input with 2 conditions false', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    when(() => tortoiseWorld.drinkLevel).thenReturn(100);
    when(() => tortoiseWorld.isWaterHere()).thenReturn(true);
    var lexer = Lexer("if capteur.eau_ici and capteur.niveau_boisson < 70: return BOIT");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String? action = program.interpret(tortoiseWorld);
    expect(action, null);
  });

  test('Execute input with 3 conditions true', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    when(() => tortoiseWorld.drinkLevel).thenReturn(40);
    when(() => tortoiseWorld.isWaterHere()).thenReturn(true);
    when(() => tortoiseWorld.isFreeAhead()).thenReturn(true);
    var lexer = Lexer("if (capteur.eau_ici and capteur.niveau_boisson < 70 and capteur.libre_devant): return BOIT");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String action = program.interpret(tortoiseWorld);
    expect(action, "BOIT");
  });

  test('Execute input with 2 lines, the first is executed', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    when(() => tortoiseWorld.isFreeAhead()).thenReturn(true);
    var lexer = Lexer("if capteur.libre_devant : return AVANCE\nreturn DROITE");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String action = program.interpret(tortoiseWorld);
    expect(action, "AVANCE");
  });

  test('Execute input with 2 lines, the second is executed', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    when(() => tortoiseWorld.isFreeAhead()).thenReturn(false);
    var lexer = Lexer("if capteur.libre_devant : return AVANCE\nreturn DROITE");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String action = program.interpret(tortoiseWorld);
    expect(action, "DROITE");
  });

  test('Execute input with if not false', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    when(() => tortoiseWorld.isFreeAhead()).thenReturn(false);
    var lexer = Lexer("if not capteur.libre_devant: return random.choice([DROITE, DROITE])");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String? action = program.interpret(tortoiseWorld);
    expect(action, "DROITE");
  });

  test('Execute input with if not true', () {
    TortoiseWorld tortoiseWorld = TortoiseWorldMock();
    when(() => tortoiseWorld.isFreeAhead()).thenReturn(true);
    var lexer = Lexer("if not capteur.libre_devant: return random.choice([DROITE, DROITE])");
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    var program = parser.parse();
    String? action = program.interpret(tortoiseWorld);
    expect(action, null);
  });
}
