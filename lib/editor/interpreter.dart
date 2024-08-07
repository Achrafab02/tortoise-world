import 'package:tortoise_world/editor/grammar/syntax_error_exception.dart';
import 'package:tortoise_world/editor/grammar/grammar.dart';
import 'package:tortoise_world/game/tortoise_world.dart';

import 'grammar/lexer.dart';
import 'grammar/parser.dart';
import 'grammar/token.dart';

/* Exemple de programme solution :
if capteur.eau_ici and capteur.niveau_boisson < 70: return BOIT
if capteur.eau_devant and capteur.niveau_boisson < 70: return AVANCE
if capteur.laitue_ici: return MANGE
if capteur.laitue_devant: return AVANCE
if not capteur.libre_devant: return random.choice([DROITE, GAUCHE])
return random.choice([AVANCE, AVANCE, AVANCE, DROITE, GAUCHE, AVANCE])
*/

class Interpreter {
  Parser? _parser;
  Expression? _program;

  String? parse(String code) {
    code = code.trim();
    _parser = _tokenizeCode(code);
    try {
      _program = _parser!.parse();
      return null;
    } on SyntaxErrorException catch (error) {
      return "Ligne ${error.line}: ${error.message}";
    } catch (error) {
      return error.toString();
    }
  }

  static Parser _tokenizeCode(code) {
    var lexer = Lexer(code);
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    return parser;
  }

  String? executeCode(TortoiseWorld tortoiseWorld) {
    return _program!.interpret(tortoiseWorld);
  }
}
