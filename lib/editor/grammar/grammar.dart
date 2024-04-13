import 'package:tortoise_world/game/tortoise_world.dart';

import 'token.dart';

abstract class Expression {
  dynamic result;

  dynamic interpret(TortoiseWorld tortoiseWorld);
}

abstract class TerminalExpression extends Expression {
  Token token;
  String action;

  TerminalExpression(this.token, this.action);
}

abstract class NonTerminalExpression extends Expression {
  final List<Expression> _expressions;

  NonTerminalExpression(this._expressions);

  List<Expression> get expressions => _expressions;

  void add(Expression expression) {
    _expressions.add(expression);
  }
}

class ArgumentListExpression extends NonTerminalExpression {
  ArgumentListExpression(super.expressions);

  @override
  String? interpret(TortoiseWorld tortoiseWorld) {
    if (expressions[0].result) {
      return expressions[1].result;
    }
    return null;
  }
}

class ProgramExpression extends NonTerminalExpression {
  ProgramExpression(super.expressions);

  @override
  String? interpret(TortoiseWorld tortoiseWorld) {
    print("%% nombre expressions ${_expressions.length}");
    if (_expressions.isNotEmpty) {
      String? result = _expressions[0].interpret(tortoiseWorld);
      if (result != null) {
        return result;
      }
      if (expressions.length > 1) {
        return expressions[1].interpret(tortoiseWorld);
      }
    }
    print("ERROR return null");
    return null;
  }
}

class IfExpression extends NonTerminalExpression {
  IfExpression(super.expressions);

  @override
  String? interpret(TortoiseWorld tortoiseWorld) {
    if (expressions[0].result) {
      return expressions[1].result;
    }
    return null;
  }
}

class ReturnExpression extends TerminalExpression {
  // TODO a quoi sert token ?
  ReturnExpression(super.token, super.action);

  @override
  String? interpret(TortoiseWorld tortoiseWorld) {
    print("** ReturnExpression returns action=${action}");
    return action;
  }
}

class BooleanSensorExpression extends TerminalExpression {
  // capteur.laitue_devant
  BooleanSensorExpression(super.token, super.action);

  @override
  dynamic interpret(TortoiseWorld tortoiseWorld) {
    switch (token.type) {
      case TokenType.FREE_AHEAD:
        return tortoiseWorld.isFreeAhead();
      case TokenType.LETTUCE_HERE:
        return tortoiseWorld.isLettuceHere();
      case TokenType.LETTUCE_AHEAD:
        return tortoiseWorld.isLettuceAhead();
      case TokenType.WATER_AHEAD:
        return tortoiseWorld.isWaterAhead();
      case TokenType.WATER_HERE:
        return tortoiseWorld.isWaterHere();
      default:
        return null;
    }
  }
}

class IntegerSensorExpression extends TerminalExpression {
  // capteur.laitue_devant
  IntegerSensorExpression(super.token, super.action);

  @override
  dynamic interpret(TortoiseWorld tortoiseWorld) {
    if (token.type == TokenType.DRINK_LEVEL) {
      return tortoiseWorld.drinkLevel;
    } else {
      return null;
    }
  }
}

class ActionExpression extends TerminalExpression {
  // AVANCE,
  ActionExpression(super.token, super.action);

  @override
  dynamic interpret(TortoiseWorld tortoiseWorld) {
    if (token.type == TokenType.DRINK_LEVEL) {
      return tortoiseWorld.drinkLevel;
    } else {
      return null;
    }
  }
}
