import "dart:math" as math;

import 'package:tortoise_world/game/tortoise_world.dart';

import 'token.dart';

// Use Interpreter Design pattern
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
  final List<Expression> instructions;

  NonTerminalExpression(this.instructions);

  List<Expression> get expressions => instructions;

  void add(Expression expression) {
    instructions.insert(0, expression);
  }
}

class ProgramExpression extends NonTerminalExpression {
  ProgramExpression(super.instructions);

  @override
  String? interpret(TortoiseWorld tortoiseWorld) {
    for (var instruction in instructions) {
      print("interpete ${instruction.runtimeType}");
      String? result = instruction.interpret(tortoiseWorld);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}

class IfExpression extends NonTerminalExpression {
  IfExpression(super.instructions);

  @override
  String? interpret(TortoiseWorld tortoiseWorld) {
    print("interprete if");
    if (instructions.isNotEmpty) {
      var conditionPart = instructions[0];
      var thenPart = instructions[1];
      print("Condition : ${conditionPart.interpret(tortoiseWorld)}");
      if (conditionPart.interpret(tortoiseWorld)) {
        return thenPart.interpret(tortoiseWorld);
      }
    }
    return null;
  }
}

class AndConditionExpression extends NonTerminalExpression {
  AndConditionExpression(super.instructions);

  @override
  bool? interpret(TortoiseWorld tortoiseWorld) {
    var operand1 = expressions[0];
    var operand2 = expressions[1];
    return operand1.interpret(tortoiseWorld) && operand2.interpret(tortoiseWorld);
  }
}

class OrConditionExpression extends NonTerminalExpression {
  OrConditionExpression(super.instructions);

  @override
  bool? interpret(TortoiseWorld tortoiseWorld) {
    var operand1 = expressions[0];
    var operand2 = expressions[1];
    return operand1.interpret(tortoiseWorld) || operand2.interpret(tortoiseWorld);
  }
}

class ConditionExpression extends NonTerminalExpression {
  ConditionExpression(super.instructions);

  @override
  String? interpret(TortoiseWorld tortoiseWorld) {
    if (expressions[0].result) {
      return expressions[1].result;
    }
    return null;
  }
}

class ReturnExpression extends NonTerminalExpression {
  // TODO a quoi sert token ?
  ReturnExpression(super.instructions);

  @override
  String? interpret(TortoiseWorld tortoiseWorld) {
    final expression = expressions[0];
    return expression.interpret(tortoiseWorld);
  }
}

/// AVANCE | DROITE | GAUCHE | MANGE | BOIT
class ActionExpression extends TerminalExpression {
  ActionExpression(super.token, super.action);

  @override
  dynamic interpret(TortoiseWorld tortoiseWorld) {
    return action;
  }
}

/// random.choice([AVANCE, DROITE)]
class RandomExpression extends TerminalExpression {
  final List<ActionExpression> argList;

  RandomExpression(super.token, super.action, this.argList);

  @override
  dynamic interpret(TortoiseWorld tortoiseWorld) {
    var rng = math.Random();
    var nextInt = rng.nextInt(argList.length);
    return argList[nextInt].action;
  }
}

class ArgumentListExpression extends NonTerminalExpression {
  ArgumentListExpression(super.instructions);

  @override
  String? interpret(TortoiseWorld tortoiseWorld) {
    if (expressions[0].result) {
      return expressions[1].result;
    }
    return null;
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

class RelationalConditionExpression extends TerminalExpression {
  final String _operator;

  RelationalConditionExpression(super.token, this._operator, super.action);

  @override
  dynamic interpret(TortoiseWorld tortoiseWorld) {
    int value;
    try {
      value = int.parse(action);
    } catch (e) {
      return null;
    }
    if (token.type == TokenType.DRINK_LEVEL) {
      switch (_operator) {
        case "<":
          return tortoiseWorld.drinkLevel < value;
        case ">":
          return tortoiseWorld.drinkLevel > value;
        case "<=":
          return tortoiseWorld.drinkLevel <= value;
        case ">=":
          return tortoiseWorld.drinkLevel >= value;
        case "==":
          return tortoiseWorld.drinkLevel == value;
        case "!=":
          return tortoiseWorld.drinkLevel != value;
      }
      return null;
    } else {
      return null;
    }
  }
}
