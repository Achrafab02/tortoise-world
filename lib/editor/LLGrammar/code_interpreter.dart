import 'dart:math';

import 'package:tortoise_world/game/tortoise_world.dart';

import 'GrammarModel.dart';
import 'Lexer.dart';
import 'Parser.dart';
import 'Token.dart';

// FIXME en fait ce n'est pas vraiment un interpréteur.
//       Ce n'est qu'un parser qui une analyse sommaire de la grammaire du code
//       -> Il faut entièrement faire l'interpréteur, ce code ne sert à pas grand chose
class CodeInterpreter {
  String _code = "";

  Parser getParser() {
    var lexer = Lexer(_code);
    var model = GrammarModel(lexer);
    var token = <Token>[];
    while (true) {
      token.add(model.lexer.getNextToken());
      if (token.last.type == TokenType.EOF) {
        break;
      }
    }
    var parser = Parser(token);
    return parser;
  }

  void setCode(String value) {
    _code = value;
  }

  String? parse(Parser parser) {
    print("Parse code $_code");
    try {
      parser.parse();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // FIXME le faux interpreteur
  String executeCode(Map<String, List<String>> _data, TortoiseWorld tortoise) {
    if (_data.containsKey('laitue_ici') && _data['laitue_ici']!.isNotEmpty && tortoise.isLettuceHere()) {
      return _data['laitue_ici']![0];
    } else if (_data.containsKey('laitue_devant') && _data['laitue_devant']!.isNotEmpty && tortoise.isLettuceAhead()) {
      return _data['laitue_devant']![0];
    } else if (_data.containsKey('libre_devant') && _data['libre_devant']!.isNotEmpty && tortoise.isFreeAhead()) {
      return _data['libre_devant']![0];
    } else if (_data.containsKey('eau_devant') && _data['eau_devant']!.isNotEmpty && tortoise.isWaterAhead()) {
      return _data['eau_devant']![0];
    } else if (_data.containsKey('eau_ici') && _data['eau_ici']!.isNotEmpty && tortoise.isWaterHere()) {
      return _data['eau_ici']![0];
    } else if (_data.containsKey('choice') && _data['choice']!.isNotEmpty) {
      // return random.choice(_data['choice']);
      var random = Random(DateTime.now().millisecondsSinceEpoch);
      return _data['choice']![random.nextInt(_data['choice']!.length)];
    } else if (_data['else']!.isNotEmpty && _data['else']!.length > (_data.keys.length - 2)) {
      return _data['else']!.last;
    }
    return 'none';
  }
}
