import 'package:flutter/foundation.dart';
import 'package:tortoise_world/editor/grammar/grammar.dart';
import 'package:tortoise_world/game/tortoise_world.dart';

import 'grammar/lexer.dart';
import 'grammar/parser.dart';
import 'grammar/token.dart';

// TODO utiliser le pattern Interpreteur pour construire une du programme
class Interpreter {
  String _code = "";
  Parser? _parser;
  Expression? _program;

  String? parse(String code) {
    // TODO construire la répresentation de la grammaire -> retourne les erreurs
    // TODO -> Expression
    // TODO il suffit ensuite de faire expression. interperete(données d'execution)
    _code = code;
    _parser = tokenizeCode(code);
    try {
      _program = _parser!.parse();
      print("** programme construit");
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
    // TODO faire return expression.interprete(expression)
    // TODO doit retrouner AVANCE, DROITE, GAUCHE, BOIT, MANGE((STOP par défaut))
    // Map<String, List<String>> _data = _parser!.resultMap.data;
    // if (_data.containsKey('laitue_ici') && _data['laitue_ici']!.isNotEmpty && tortoiseWorld.isLettuceHere()) {
    //   return _data['laitue_ici']![0];
    // } else if (_data.containsKey('laitue_devant') && _data['laitue_devant']!.isNotEmpty && tortoiseWorld.isLettuceAhead()) {
    //   return _data['laitue_devant']![0];
    // } else if (_data.containsKey('libre_devant') && _data['libre_devant']!.isNotEmpty && tortoiseWorld.isFreeAhead()) {
    //   return _data['libre_devant']![0];
    // } else if (_data.containsKey('eau_devant') && _data['eau_devant']!.isNotEmpty && tortoiseWorld.isWaterAhead()) {
    //   return _data['eau_devant']![0];
    // } else if (_data.containsKey('eau_ici') && _data['eau_ici']!.isNotEmpty && tortoiseWorld.isWaterHere()) {
    //   return _data['eau_ici']![0];
    // } else if (_data.containsKey('choice') && _data['choice']!.isNotEmpty) {
    //   // return random.choice(_data['choice']);
    //   var random = Random(DateTime.now().millisecondsSinceEpoch);
    //   return _data['choice']![random.nextInt(_data['choice']!.length)];
    // } else if (_data['else']!.isNotEmpty && _data['else']!.length > (_data.keys.length - 2)) {
    //   return _data['else']!.last;
    // }
    // return 'none';
  }
}
