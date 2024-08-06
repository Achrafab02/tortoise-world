import 'package:flutter/cupertino.dart';
import 'package:tortoise_world/editor/grammar/SyntaxErrorException.dart';
import 'package:tortoise_world/editor/grammar/grammar.dart';

/// LL(1) Grammar
///
///   pg : instruction pg
///      | ε
///
/// instruction : if_instruction
///             | return_instruction
///
/// return_instruction : RETURN CONSTANT
///                    | RETURN RANDOM array
///
/// array : [ argList ]
///
/// arg_list : CONSTANT
///          | CONSTANT COMA arg_list
///
/// if_instruction : IF condition COLON instruction
///
/// condition : LPAREN condition RPAREN
///           | simple_condition AND condition
///           | simple_condition OR condition
///           | NOT simple_condition
///
/// simple_condition : sensor
///                  | DRINK_LEVEL RELATION_OPERATOR INTEGER
///
/// sensor: SENSOR DOT VALUE
import 'token.dart';

class Parser {
  final List<Token> _tokens;
  int _currentTokenIndex = 0;
  int _currentLineNumber = 1;

  Parser(this._tokens);

  Token get currentToken => _tokens[_currentTokenIndex];

  Token get lastToken => _tokens[_currentTokenIndex - 1];

  Expression parse() {
    return _pg();
  }

  Expression _pg() {
    if (currentToken.type != TokenType.EOF) {
      Expression instruction = _instruction();
      if (_match(TokenType.EOL)) {
        _currentLineNumber++;
      }
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
      throw SyntaxErrorException(_currentLineNumber, "Début d'instruction inconnue : ${currentToken.lexeme}");
    }
  }

  Expression _returnInstruction() {
    if (_match(TokenType.LPAREN)) {
      // expression:: return (AVANCE)
      if (isAction(currentToken.type)) {
        String action = currentToken.lexeme;
        var token = currentToken;
        if (_match(currentToken.type)) {
          if (!_match(TokenType.RPAREN)) {
            throw SyntaxErrorException(_currentLineNumber, "Parenthèse fermante manquante");
          }
          return ReturnExpression([ActionExpression(token, action)]);
        }
      } else {
        // TODO regarder s'il s'agit de la version minuscule -> message d'erreur  il faut des majuscules
        throw SyntaxErrorException(_currentLineNumber, "Action inconnue ${currentToken.lexeme}");
      }
    } else if (isAction(currentToken.type)) {
      // expression:: return AVANCE
      String action = currentToken.lexeme;
      if (_match(currentToken.type)) {
        return ReturnExpression([ActionExpression(currentToken, action)]);
      }
    } else if (currentToken.type == TokenType.RANDOM) {
      // expression:: return random.choice([AVANCE, DROITE)
      return ReturnExpression([_randomChoice()]);
    }
    // TODO regarder s'il s'agit de la version minuscule -> message d'erreur -> il faut des majuscules
    throw SyntaxErrorException(_currentLineNumber, "Action inconnue ${currentToken.lexeme}");
  }

  Expression _randomChoice() {
    // expression:: random.choice([AVANCE]) or random.choice([AVANCE, DROITE])
    if (_match(TokenType.RANDOM)) {
      if (_match(TokenType.LPAREN)) {
        List<ActionExpression> argList = _array();
        if (_match(TokenType.RPAREN)) {
          return RandomExpression(currentToken, "", argList);
        }
        throw SyntaxErrorException(_currentLineNumber, "Parenthèse fermante manquante");
      }
      throw SyntaxErrorException(_currentLineNumber, "Manque une parenthèse ouvrante après random.choice");
    }
    throw SyntaxErrorException(_currentLineNumber, "Manque random.choice()");
  }

  List<ActionExpression> _array() {
    if (_match(TokenType.LBRACKET)) {
      List<ActionExpression> array = _argumentList();
      if (_match(TokenType.RBRACKET)) {
        return array;
      }
      // return random.choice([AVANCE])
      throw SyntaxErrorException(_currentLineNumber, "Manquante un crochet fermant");
    }
    throw SyntaxErrorException(_currentLineNumber, "Manquante un crochet ouvrant");
  }

  List<ActionExpression> _argumentList() {
    // arg_list : CONSTANT
    //          | CONSTANT COMA arg_list
    if (isAction(currentToken.type)) {
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
      } else {
        throw SyntaxErrorException(_currentLineNumber, "Manque un crochet fermant");
      }
    }
    throw SyntaxErrorException(_currentLineNumber, "Manque une action : AVANCE, BOIT...");
  }

  Expression _ifInstruction() {
    // if_instruction : IF condition COLON instruction
    Expression condition = _condition();
    if (_match(TokenType.COLON)) {
      Expression instruction = _instruction();
      return IfExpression([condition, instruction]);
    } else {
      throw SyntaxErrorException(_currentLineNumber, "Manque un ':' après la condition");
    }
  }

  Expression _condition() {
    // condition : LPAREN condition RPAREN
    //           | simple_condition AND condition
    //           | simple_condition OR condition
    //           | NOT simple_condition
    if (_match(TokenType.LPAREN)) {
      var condition = _condition();
      if (_match(TokenType.RPAREN)) {
        return condition;
      } else {
        throw SyntaxErrorException(_currentLineNumber, "Parenthèse fermante manquante");
      }
    } else if (_match(TokenType.NOT)) {
      var conditionSimple = _conditionSimple();
      return NotConditionExpression([conditionSimple]);
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
    // simple_condition : FREE_HEAD | WATER_AHEAD | WATER_HERE...
    //                  | DRINK_LEVEL RELATIONAL_OPERATOR INTEGER
    var token = currentToken;
    if (_match(TokenType.DRINK_LEVEL)) {
      /// capteur_niveau_boisson > 10
      if (currentToken.type == TokenType.GREATER //
          ||
          currentToken.type == TokenType.GREATER_EQUAL //
          ||
          currentToken.type == TokenType.EQUAL //
          ||
          currentToken.type == TokenType.LESS //
          ||
          currentToken.type == TokenType.LESS_EQUAL //
          ||
          currentToken.type == TokenType.NOT_EQUAL) {
        var relationalOperator = currentToken;
        _match(currentToken.type);
        var integer = currentToken;
        if (_match(TokenType.INTEGER)) {
          return RelationalConditionExpression(token, relationalOperator.lexeme, integer.lexeme);
        }
        throw SyntaxErrorException(_currentLineNumber, "Il faut un entier après l'opérateur relationnel ${relationalOperator.lexeme}");
      }
    } else if (_match(TokenType.FREE_AHEAD)) {
      return BooleanSensorExpression(token, "");
    } else if (_match(TokenType.WATER_AHEAD)) {
      return BooleanSensorExpression(token, "");
    } else if (_match(TokenType.WATER_HERE)) {
      return BooleanSensorExpression(token, "");
    } else if (_match(TokenType.LETTUCE_AHEAD)) {
      return BooleanSensorExpression(token, "");
    } else if (_match(TokenType.LETTUCE_HERE)) {
      return BooleanSensorExpression(token, "");
    }
    throw SyntaxErrorException(_currentLineNumber, "Expression inattendue ${token.lexeme}");
  }

  @visibleForTesting
  static bool isAction(TokenType tokenType) {
    return [
      TokenType.FORWARD,
      TokenType.LEFT,
      TokenType.RIGHT,
      TokenType.DRINK,
      TokenType.EAT,
    ].contains(tokenType);
  }

  bool _match(TokenType type) {
    if (currentToken.type == type) {
      _currentTokenIndex++;
      return true;
    }
    return false;
  }
}

class Symbol {
  String? action;
}
