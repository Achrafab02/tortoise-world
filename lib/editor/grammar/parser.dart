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

// TODO Manque toute la gestion des erreurs
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
      return _ifInstruction();
    } else if (_match(TokenType.RETURN)) {
      return _returnInstruction();
    } else {
      throw Exception("Instruction inconnue");
    }
  }

  Expression _returnInstruction() {
    if (_match(TokenType.LPAREN)) {
      // expression:: return AVANCE
      if (_isAction(currentToken)) {
        String action = currentToken.lexeme;
        if (_match(currentToken.type)) {
          return ReturnExpression([ActionExpression(currentToken, action)]);
        } else {
          throw Exception("Commande inconnue ${action}");
        }
      }
      if (_match(TokenType.RPAREN)) {
        throw Exception("Parenthèse fermante manquante");
      }
    } else if (_isAction(currentToken)) {
      // expression:: return AVANCE
      String action = currentToken.lexeme;
      if (_match(currentToken.type)) {
        return ReturnExpression([ActionExpression(currentToken, action)]);
      }
    } else if (currentToken.type == TokenType.RANDOM) {
      // expression:: return random.choice([AVANCE, DROITE)
      return ReturnExpression([_randomChoice()]);
    }
    throw Exception("Expression inattendue ${currentToken.lexeme}");
  }

  Expression _randomChoice() {
    // expression:: random.choice([AVANCE]) or random.choice([AVANCE, DROITE])
    if (_match(TokenType.RANDOM)) {
      if (_match(TokenType.LPAREN)) {
        List<ActionExpression> argList = _array();
        if (_match(TokenType.RPAREN)) {
          return RandomExpression(currentToken, "", argList);
        }
      }
      throw Exception("Manque choice après random");
    }
    throw Exception("Ne devrait jamais arriver");
  }

  List<ActionExpression> _array() {
    if (_match(TokenType.LBRACKET)) {
      List<ActionExpression> array = _argumentList();
      if (_match(TokenType.RBRACKET)) {
        return array;
      }
    }
    throw Exception("Manquante un crochet ouvrant");
  }

  List<ActionExpression> _argumentList() {
    if (_isAction(currentToken)) {
      var token = currentToken;
      var lexeme = currentToken.lexeme;
      _match(currentToken.type);
      var argument = ActionExpression(token, lexeme);
      if (_match(TokenType.COMMA)) {
        List<ActionExpression> argList = _argumentList();
        argList.insert(0, argument);
        return argList;
      } else if (currentToken.type == TokenType.RBRACKET) {
        // un seul ou dernier argument
        return [argument];
      }
      throw Exception("Erreur??");
    }
    throw Exception(" ??");
  }

  bool _isAction(token) => token.type == TokenType.FORWARD || token.type == TokenType.LEFT || token.type == TokenType.RIGHT || token.type == TokenType.DRINK || token.type == TokenType.EAT;

  Expression _ifInstruction() {
    Expression condition = _condition();
    if (_match(TokenType.COLON)) {
      Expression instruction = _instruction();
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
        return condition;
      }
      throw Exception("Parenthèse fermante manquante");
    } else if (_match(TokenType.NOT)) {
      var conditionSimple = _conditionSimple();
      var not = BooleanSensorExpression(currentToken, "not");
      return ConditionExpression([not, conditionSimple]);
    } else {
      var simpleCondition = _conditionSimple();
      if (_match(TokenType.AND)) {
        var condition = _condition();
        return AndConditionExpression([simpleCondition, condition]);
      } else if (_match(TokenType.OR)) {
        var condition = _condition();
        return OrConditionExpression([simpleCondition, condition]);
      }
      return simpleCondition;
    }
  }

  Expression _conditionSimple() {
    // condition_simple : sensorExpression RELATION_OPERATOR INTEGER
    //                  | sensorExpression
    //                  | NOT sensorExpression
    var token = currentToken;
    if (currentToken.type == TokenType.DRINK_LEVEL) {
      /// capteur_niveau_boisson > 10
      _match(TokenType.DRINK_LEVEL);
      if (currentToken.type == TokenType.GREATER || currentToken.type == TokenType.GREATER_EQUAL || currentToken.type == TokenType.EQUAL || currentToken.type == TokenType.LESS || currentToken.type == TokenType.LESS_EQUAL || currentToken.type == TokenType.NOT_EQUAL) {
        var relationalOperator = currentToken;
        _match(currentToken.type);
        var integer = currentToken;
        if (_match(TokenType.INTEGER)) {
          return RelationalConditionExpression(token, relationalOperator.lexeme, integer.lexeme  );
        }
        throw Exception("Il faut un entier après l'opérateur de comparaison");
      }
    } else if (currentToken.type == TokenType.FREE_AHEAD) {
      _match(TokenType.FREE_AHEAD);
      return BooleanSensorExpression(token, "");
    } else if (currentToken.type == TokenType.WATER_AHEAD) {
      _match(TokenType.WATER_AHEAD);
      return BooleanSensorExpression(token, "");
    } else if (currentToken.type == TokenType.WATER_HERE) {
      _match(TokenType.WATER_HERE);
      return BooleanSensorExpression(token, "");
    } else if (currentToken.type == TokenType.LETTUCE_AHEAD) {
      _match(TokenType.LETTUCE_AHEAD);
      return BooleanSensorExpression(token, "");
    } else if (currentToken.type == TokenType.LETTUCE_HERE) {
      _match(TokenType.LETTUCE_HERE);
      return BooleanSensorExpression(token, "");
    }
    throw Exception("Expression inattendue ${token.lexeme}");
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
