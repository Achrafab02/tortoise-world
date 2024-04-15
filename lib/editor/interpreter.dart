import 'package:flutter/foundation.dart';
import 'package:tortoise_world/editor/grammar/grammar.dart';
import 'package:tortoise_world/game/tortoise_world.dart';

import 'grammar/lexer.dart';
import 'grammar/parser.dart';
import 'grammar/token.dart';

// TODO utiliser le pattern Interpreteur pour construire une du programme
class Interpreter {
  Parser? _parser;
  Expression? _program;

  String? parse(String code) {
    // TODO construire la répresentation de la grammaire -> retourne les erreurs
    // TODO -> Expression
    // TODO il suffit ensuite de faire expression. interperete(données d'execution)
    _parser = tokenizeCode(code);
    try {
      _program = _parser!.parse();
      print("** Programme construit..");
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @visibleForTesting
  static Parser tokenizeCode(code) {
    var lexer = Lexer(code);
    List<Token> token = lexer.tokenizeCode();
    var parser = Parser(token);
    return parser;
  }

  // FIXME en fait ce n'est pas vraiment un interpréteur.
  //       Ce n'est qu'un parser qui donne une analyse sommaire de la grammaire du code
  //       -> Il faut entièrement faire l'interpréteur, ce code ne sert à pas grand chose
  String executeCode(TortoiseWorld tortoiseWorld) {
    return _program!.interpret(tortoiseWorld);
  }
}
