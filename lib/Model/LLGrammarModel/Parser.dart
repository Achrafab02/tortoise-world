import 'Token.dart';
import 'package:tortoise_world/Model/model.dart';
/*
  *  LL(1) Grammar
  * S -> instruction S | ε
  * instruction -> IF condition COLON S (ELSE (IF condition COLON S | COLON S))? | RETURN args | otherStatement
  * condition -> (IDENTIFIER DOT IDENTIFIER | LPAREN condition RPAREN | LBRACKET expression RBRACKET) (AND condition)? (OR condition)? (LESS | LESS_EQUAL | GREATER | GREATER_EQUAL | EQUAL) identifierOrConstant (DOT IDENTIFIER)?
  * otherStatement -> IDENTIFIER (DOT IDENTIFIER LPAREN args RPAREN)?
               | RETURN args
               | ELSE (IF condition COLON S | COLON S)?
  * args -> argList | CONSTANT
  * argList -> expression (COMMA argList | RPAREN | RBRACKET)
  * expression -> identifierOrConstant AND expression | identifierOrConstant
  * identifierOrConstant -> IDENTIFIER (DOT IDENTIFIER (LPAREN | LBRACKET)?)? | CONSTANT | LPAREN expression RPAREN
  * arguments -> LPAREN argList RPAREN | LBRACKET argList (RBRACKET | RPAREN)
 */

class ResultMap {
  Map<String, List<String>> _data = {
    'vide': [],
  };

  void add(String key, String value) {
    if (!_data.containsKey(key)) {
      _data[key] = [];
    }
    _data[key]?.add(value);
  }

  void addkey(String key) {
    if (!_data.containsKey(key)) {
      _data[key] = [];
    }
  }

  Map<String, List<String>> get data => _data;



  List<String> get(String key) {
    return _data[key]!;
  }
}


class Parser {
  final List<Token> tokens;
  int currentTokenIndex = 0;


  Parser(this.tokens);

  Token get currentToken => tokens[currentTokenIndex];
  Token get lastToken => tokens[currentTokenIndex - 1];

  ResultMap resultMap = ResultMap();


  /*
  var sensors = {
    'vide': true,
    'libre_devant': false,
    'laitue_devant': false,
    'laitue_ici': false,
    'eau_devant': false,
    'eau_ici': false,
  };


  List<String> result = [];

   */

  bool match(TokenType type) {
    if (currentToken.type == type) {
      currentTokenIndex++;
      return true;
    }
    return false;
  }

  void parse() {
    S();
    if (currentToken.type != TokenType.EOF) {
      throw Exception('faute de syntaxe');
    }
  }

  void S() {
    if (currentToken.type != TokenType.EOF) {
      instruction();
      S();
    }
  }

  void instruction() {
    if (match(TokenType.IF)) {
      condition();
      if (!match(TokenType.COLON)) {
        throw Exception('Il faut un deux points après la condition');
      }
      S();
      if (match(TokenType.ELSE)) {
        if (match(TokenType.IF)) {
          condition();
          if (!match(TokenType.COLON)) {
            throw Exception('Il faut un deux points après la condition');
          }
          S();
        } else {
          if (!match(TokenType.COLON)) {
            throw Exception('Il faut un deux points après else');
          }
          S();
        }
      }
    } else if (match(TokenType.RETURN)) {
      args();
    } else {
      otherStatement();
    }
  }

  void condition() {
    if (match(TokenType.IDENTIFIER)) {
      if (match(TokenType.DOT)) {
        String Sensor = currentToken.lexeme;
        if (!match(TokenType.IDENTIFIER)) {
          throw Exception('Il faut un identifiant après le point');
        } else {
          resultMap.addkey(Sensor);
          resultMap.add('vide', Sensor);
        }
      }
    } else if (match(TokenType.LPAREN)) {
      condition();
      if (!match(TokenType.RPAREN)) {
        throw Exception('Il faut une parenthèse fermante');
      }
    } else if (match(TokenType.LBRACKET)) {
      expression();
      if (!match(TokenType.RBRACKET)) {
        throw Exception('Il faut un crochet fermant');
      }
    } else {
      condition();
    }

    if (match(TokenType.AND) || match(TokenType.OR)) {
      condition();
    }

    if (match(TokenType.LESS) ||
        match(TokenType.LESS_EQUAL) ||
        match(TokenType.GREATER) ||
        match(TokenType.GREATER_EQUAL) ||
        match(TokenType.EQUAL)) {
      identifierOrConstant();
    }

    if (match(TokenType.DOT)) {
      if (!match(TokenType.IDENTIFIER)) {
        throw Exception('Il faut un identifiant après le point');
      }
    }
  }

  void otherStatement() {
    if (match(TokenType.IDENTIFIER)) {
      if (match(TokenType.DOT)) {
        if (!match(TokenType.IDENTIFIER)) {
          throw Exception('Il faut un identifiant après le point');
        }
        if (!match(TokenType.LPAREN)) {
          throw Exception(
              'Il faut une parenthèse ouvrante après l\'identifiant');
        }
        args();
        if (!match(TokenType.RPAREN)) {
          throw Exception(
              'Il faut une parenthèse fermante après les arguments');
        }
      }
    } else if (match(TokenType.RETURN)) {
      args();
    } else {
      if (match(TokenType.ELSE)) {
        if (match(TokenType.IF)) {
          condition();
          if (!match(TokenType.COLON)) {
            throw Exception('Il faut un deux points après la condition');
          }
          S();
        } else {
          if (!match(TokenType.COLON)) {
            throw Exception('Il faut un deux points après else');
          }
          S();
        }
      } else {}
    }
  }

  void args() {
    if (currentToken.type == TokenType.IDENTIFIER ||
        currentToken.type == TokenType.LPAREN) {
      argList();
    } else if (currentToken.type == TokenType.CONSTANT) {
      String Result = currentToken.lexeme;
      if (match(TokenType.CONSTANT)) {
        resultMap.add(resultMap._data.keys.last, Result);
        resultMap.add('vide', Result);
      }
    }
  }

  void argList() {
    expression();
    if (match(TokenType.COMMA)) {
      argList();
    } else if (match(TokenType.RPAREN) || match(TokenType.RBRACKET)) {
      return;
    }
  }

  void expression() {
    identifierOrConstant();
    if (match(TokenType.AND)) {
      expression();
    }
  }

  void identifierOrConstant() {
    if (match(TokenType.IDENTIFIER)) {
      if (match(TokenType.DOT)) {
        String Sensor = currentToken.lexeme;
        if (!match(TokenType.IDENTIFIER)) {
          throw Exception('Il faut un identifiant après le point');
        }
        resultMap.addkey(Sensor);
        if (match(TokenType.LPAREN) || match(TokenType.LBRACKET)) {
          arguments();
        }
      }
    } else if (match(TokenType.CONSTANT)) {
      String Result = lastToken.lexeme;
      resultMap.add(resultMap._data.keys.last, Result);
      resultMap.add('vide', Result);
    } else if (match(TokenType.LPAREN)) {
      expression();
      if (!match(TokenType.RPAREN)) {
        throw Exception('Il faut une parenthèse fermante après l\'expression');
      }
    }
  }

  void arguments() {
    if (match(TokenType.LPAREN)) {
      argList();
      if (!match(TokenType.RPAREN)) {
        throw Exception('Il faut une parenthèse fermante après les arguments');
      }
    } else if (match(TokenType.LBRACKET)) {
      argList();
      if (!match(TokenType.RBRACKET) && !match(TokenType.RPAREN)) {
        throw Exception('Il faut un crochet fermant ou une parenthèse fermante');
      }
    }
  }
}
