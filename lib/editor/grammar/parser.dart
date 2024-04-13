import 'package:tortoise_world/editor/grammar/grammar.dart';

/*
 * LL(1) Grammar
 * pg : instructionExpression pg
 *    | ε
 * instructionExpresion : ifExpression
 *                      | returnExpression
 * returnExpression : RETURN CONSTANT
 *                  | RETURN RANDOM DOT CHOICE arrayExpression
 * arrayExpression : [ argList ]
 * argList : CONSTANT
 *         | CONSTANT COMA argList
 * ifExpression : IF conditionExpression COLON instructionExpression (TODO les tabulations)
 * conditionExpression : sensorExpression
 *                     | sensorExpression RELATION_OPERATOR INTEGER
 *                     | LPAREN conditionExpression RPAREN
 *                     | NOT conditionExpression
 *                     | conditionExpression AND conditionExpression
 *                     | conditionExpression OR conditionExpression
 * sensorExpression: SENSOR DOT VALUE
 */
import 'token.dart';

// TODO refaire les TU
class Parser {
  final List<Token> _tokens;
  int currentTokenIndex = 0;

  Parser(this._tokens);

  Token get currentToken => _tokens[currentTokenIndex];

  Token get lastToken => _tokens[currentTokenIndex - 1];

  Expression parse() {
    return _pg();
  }

  Expression _pg() {
    if (currentToken.type != TokenType.EOF) {
      Expression instruction = _instruction();
      ProgramExpression pg = _pg() as ProgramExpression;
      pg.add(instruction);
      return pg;
    }
    return ProgramExpression([]);
  }

  Expression _instruction() {
    if (_match(TokenType.IF)) {
      _ifCondition();
      if (!_match(TokenType.COLON)) {
        throw Exception('Il faut un deux points après la condition');
      }
      return _pg();
    } else if (_match(TokenType.RETURN)) {
      return _returnExpression();
    } else {
      return otherStatement();
    }
  }

  Expression _returnExpression() {
    if (_match(TokenType.LPAREN)) {
      // expression:: return ( AVANCE )
      if (currentToken.type == TokenType.CONSTANT) {
        String action = currentToken.lexeme;
        if (_match(TokenType.CONSTANT)) {
          return ReturnExpression(currentToken, action);
        } else {
          throw Exception("Commande inconnue ${action}");
        }
      }
      if (_match(TokenType.RPAREN)) {
        throw Exception("Parenthèse fermante manquante");
      }
    } else if (currentToken.type == TokenType.CONSTANT) {
      // expression:: return AVANCE
      String action = currentToken.lexeme;
      if (_match(TokenType.CONSTANT)) {
        return ReturnExpression(currentToken, action);
      }
    } else if (currentToken.type == TokenType.RANDOM) {
      // expression:: return random.choice([AVANCE, DROITE)
      return _randomExpression();
    }
    throw Exception("Expression inattendue ${currentToken.lexeme}");
  }

  Expression _randomExpression() {
    // expression:: random.choice([AVANCE]) or random.choice([AVANCE, DROITE])
    if (_match(TokenType.RANDOM)) {
      if (_match(TokenType.LPAREN)) {
        Expression argList1 = _arrayExpression();
        if (_match(TokenType.RPAREN)) {
          return argList1;
        }
      }
      throw Exception("Manque choice après random");
    }
    throw Exception("Ne devrait jamais arriver");
  }

  Expression _arrayExpression() {
    if (_match(TokenType.LBRACKET)) {
      Expression array = _argumentList();
      if (_match(TokenType.RBRACKET)) {
        return array;
      }
    }
    throw Exception("Manquante un crochet ouvrant");
  }

  Expression _argumentList() {
    if (_match(TokenType.CONSTANT)) {
      var token = currentToken;
      var action = currentToken.lexeme;
      var argument = ActionExpression(token, action);
      if (_match(TokenType.COMMA)) {
        ArgumentListExpression argList = _argumentList() as ArgumentListExpression;
        argList.add(argument);
        return argList;
      } else if (_match(TokenType.RBRACKET)) {
        // un seul ou dernier argument
        return ArgumentListExpression([argument]);
      }
      throw Exception("Erreur??");
    }
    throw Exception("??");
  }

  Expression _ifCondition() {
    throw Exception("Not implemented");
    // if (_match(TokenType.IDENTIFIER)) {
    //   if (_match(TokenType.DOT)) {
    //     String sensor = currentToken.lexeme;
    //     if (!_match(TokenType.IDENTIFIER)) {
    //       throw Exception('Il faut un identifiant après le point');
    //     } else {
    //       // resultMap.addkey(sensor);
    //       // resultMap.add('vide', sensor);
    //     }
    //   }
    // } else if (_match(TokenType.LPAREN)) {
    //   _ifCondition();
    //   if (!_match(TokenType.RPAREN)) {
    //     throw Exception('Il faut une parenthèse fermante');
    //   }
    // } else if (_match(TokenType.LBRACKET)) {
    //   expression();
    //   if (!_match(TokenType.RBRACKET)) {
    //     throw Exception('Il faut un crochet fermant');
    //   }
    // } else {
    //   _ifCondition();
    // }
    //
    // if (_match(TokenType.AND) || _match(TokenType.OR)) {
    //   _ifCondition();
    // }
    //
    // if (_match(TokenType.LESS) || _match(TokenType.LESS_EQUAL) || _match(TokenType.GREATER) || _match(TokenType.GREATER_EQUAL) || _match(TokenType.EQUAL)) {
    //   identifierOrConstant();
    // }
    //
    // if (_match(TokenType.DOT)) {
    //   if (!_match(TokenType.IDENTIFIER)) {
    //     throw Exception('Il faut un identifiant après le point');
    //   }
    // }
  }

  Expression otherStatement() {
    throw Exception("Not implemented");
    // if (_match(TokenType.IDENTIFIER)) {
    //   if (_match(TokenType.DOT)) {
    //     if (!_match(TokenType.IDENTIFIER)) {
    //       throw Exception('Il faut un identifiant après le point');
    //     }
    //     if (!_match(TokenType.LPAREN)) {
    //       throw Exception('Il faut une parenthèse ouvrante après l\'identifiant');
    //     }
    //     _returnExpression();
    //     if (!_match(TokenType.RPAREN)) {
    //       throw Exception('Il faut une parenthèse fermante après les arguments');
    //     }
    //   }
    // } else if (_match(TokenType.RETURN)) {
    //   _returnExpression();
    // }
  }

  Expression expression() {
    throw Exception("Not implemented");
    // identifierOrConstant();
    // if (_match(TokenType.AND)) {
    //   expression();
    // }
  }

  Expression identifierOrConstant() {
    throw Exception("Not implemented");
    // if (_match(TokenType.IDENTIFIER)) {
    //   if (_match(TokenType.DOT)) {
    //     String sensor = currentToken.lexeme;
    //     if (!_match(TokenType.IDENTIFIER)) {
    //       throw Exception('Il faut un identifiant après le point');
    //     }
    //     // resultMap.addkey(sensor);
    //     if (_match(TokenType.LPAREN) || _match(TokenType.LBRACKET)) {
    //       arguments();
    //     }
    //   }
    // } else if (_match(TokenType.CONSTANT)) {
    //   String result = lastToken.lexeme;
    //   // resultMap.add(resultMap._data.keys.last, result);
    //   // resultMap.add('vide', result);
    // } else if (_match(TokenType.LPAREN)) {
    //   expression();
    //   if (!_match(TokenType.RPAREN)) {
    //     throw Exception('Il faut une parenthèse fermante après l\'expression');
    //   }
    // }
  }

  Expression arguments() {
    if (_match(TokenType.LPAREN)) {
      var argList1 = _arrayExpression();
      if (!_match(TokenType.RPAREN)) {
        throw Exception('Il faut une parenthèse fermante après les arguments');
      }
      return argList1;
    } else if (_match(TokenType.LBRACKET)) {
      var argList1 = _arrayExpression();
      if (!_match(TokenType.RBRACKET) && !_match(TokenType.RPAREN)) {
        throw Exception('Il faut un crochet fermant ou une parenthèse fermante');
      }
      return argList1;
    }
    throw Exception("??");
  }

  bool _match(TokenType type) {
    if (currentToken.type == type) {
      currentTokenIndex++;
      return true;
    }
    return false;
  }
}

class Symbol {
  String? action;
}
