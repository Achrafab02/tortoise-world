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
 * conditionExpression : LPAREN conditionExpression RPAREN
 *                     | simpleConditionExpression AND conditionExpression
 *                     | simpleConditionExpression OR conditionExpression
 * simpleConditionExpression : sensorExpression
 *                           | NOT sensorExpression
 *                           | sensorExpression RELATION_OPERATOR INTEGER
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
      return _if();
    } else if (_match(TokenType.RETURN)) {
      return _returnInstruction();
    } else {
      throw Exception("Instruction inconnue");
    }
  }

  Expression _returnInstruction() {
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
      return _randomChoice();
    }
    throw Exception("Expression inattendue ${currentToken.lexeme}");
  }

  Expression _randomChoice() {
    // expression:: random.choice([AVANCE]) or random.choice([AVANCE, DROITE])
    if (_match(TokenType.RANDOM)) {
      if (_match(TokenType.LPAREN)) {
        Expression argList1 = _array();
        if (_match(TokenType.RPAREN)) {
          return argList1;
        }
      }
      throw Exception("Manque choice après random");
    }
    throw Exception("Ne devrait jamais arriver");
  }

  Expression _array() {
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

  Expression _if() {
    Expression condition = _condition();
    if (_match(TokenType.COLON)) {
      var instruction = _instruction();
      return IfExpression([condition, instruction]);
    } else {
      throw Exception("Manque un : ");
    }
  }

  Expression _condition() {
    // condition : LPAREN condition RPAREN
    //           | condition_simple AND condition
    //           | condition_simple OR condition
    if (_match(TokenType.LPAREN)) {
      var condition = _condition();
      if (_match(TokenType.RPAREN)) {
        return ConditionExpression([condition]);
      }
      throw Exception("Parenthèse fermante manquante");
    } else {
      var simpleCondition = _conditionSimple();
      if (_match(TokenType.AND)) {
        var condition = _condition();
        return AndConditionExpression([simpleCondition, condition]);
      } else if (_match(TokenType.OR)) {
        var condition = _condition();
        return OrConditionExpression([simpleCondition, condition]);
      }
      throw Exception("Expression inattendue ${currentToken.lexeme}");
    }
  }

  Expression _conditionSimple() {
    // condition_simple : sensorExpression RELATION_OPERATOR INTEGER
    //                  | sensorExpression
    //                  | NOT sensorExpression
    if (currentToken.type == TokenType.NOT) {
      return BooleanSensorExpression(currentToken, "not");
    } else if (currentToken.type == TokenType.DRINK_LEVEL) {
      // capteur_niveau_boisson > 10
      _match(TokenType.DRINK_LEVEL);
      var sensor = currentToken.lexeme;
      if (currentToken.type == TokenType.GREATER || currentToken.type == TokenType.GREATER_EQUAL || currentToken.type == TokenType.EQUAL || currentToken.type == TokenType.LESS || currentToken.type == TokenType.LESS_EQUAL || currentToken.type == TokenType.NOT_EQUAL) {
        var relationalOperator = currentToken.lexeme;
        _match(currentToken.type);
        if (currentToken.type == TokenType.INTEGER) {
          return RelationalConditionExpression(currentToken, relationalOperator, currentToken.lexeme);
        }
        throw Exception("Il faut un entier après l'opérateur de comparaison");
      }
    } else if (currentToken.type == TokenType.FREE_AHEAD) {
      _match(TokenType.FREE_AHEAD);
      return BooleanSensorExpression(currentToken, "");
    } else if (currentToken.type == TokenType.WATER_AHEAD) {
      _match(TokenType.WATER_AHEAD);
      return BooleanSensorExpression(currentToken, "");
    } else if (currentToken.type == TokenType.WATER_HERE) {
      _match(TokenType.WATER_HERE);
      return BooleanSensorExpression(currentToken, "");
    } else if (currentToken.type == TokenType.LETTUCE_AHEAD) {
      _match(TokenType.LETTUCE_AHEAD);
      return BooleanSensorExpression(currentToken, "");
    } else if (currentToken.type == TokenType.LETTUCE_HERE) {
      _match(TokenType.LETTUCE_HERE);
      return BooleanSensorExpression(currentToken, "");
    }
    throw Exception("Expression inattendue ${currentToken.lexeme}");
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
