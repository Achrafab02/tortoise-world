import 'Token.dart';

class Parser {
  final List<Token> tokens;
  int currentTokenIndex = 0;

  Parser(this.tokens);

  void parse() {
    S();
  }

  void S() {
    while (currentToken().type != TokenType.EOF) {
      instruction();
    }
  }

  void instruction() {
    if (match(TokenType.IF)) {
      ifStatement();
    } else if (match(TokenType.RETURN)) {
      returnStatement();
    } else {
      otherStatement();
    }
  }

  void ifStatement() {
    consume(TokenType.IF);
    condition();
    if (match(TokenType.COLON)) {
      consume(TokenType.COLON);
      S();
    } else {
      // Handle logical operators
      if (match(TokenType.AND) || match(TokenType.OR)) {
        consume(currentToken().type); // Consume logical operator
        if (match(TokenType.COLON)) {
          consume(TokenType.COLON);
          S();
        }
      } else {
        throw Exception('Unexpected token: ${currentToken().lexeme}. Expected: TokenType.COLON');
      }
    }

    if (match(TokenType.ELSE)) {
      consume(TokenType.ELSE);
      consume(TokenType.COLON);
      S();
    }
  }

  void returnStatement() {
    consume(TokenType.RETURN);
    expression();
  }

  void otherStatement() {
    if (match(TokenType.IDENTIFIER)) {
      identifier();
      consume(TokenType.DOT);
      identifier();
      consume(TokenType.LPAREN);
      args();
      consume(TokenType.RPAREN);
    } else if (match(TokenType.RETURN)) {
      consume(TokenType.RETURN);
      args();
    } else if (match(TokenType.ELSE)) {
      consume(TokenType.ELSE);
      if (match(TokenType.COLON)) {
        consume(TokenType.COLON);
        S();
      }
    } else {
      throw Exception('Unexpected token: ${currentToken().lexeme}');
    }
  }

  void condition() {
    if (match(TokenType.IDENTIFIER)) {
      identifier();
      consume(TokenType.DOT);
      identifier();
    } else if (match(TokenType.LPAREN)) {
      consume(TokenType.LPAREN);
      condition();
      consume(TokenType.RPAREN);
    } else {
      condition();
      consume(TokenType.AND);
      condition();
      // Add support for 'or' condition here if needed
    }
  }

  void expression() {
    if (match(TokenType.IDENTIFIER) || match(TokenType.CONSTANT) || match(TokenType.LPAREN)) {
      identifierOrConstant();
    } else {
      expression();
      consume(TokenType.AND);
      expression();
      // Add support for 'or' expression here if needed
    }
  }

  void identifierOrConstant() {
    if (match(TokenType.IDENTIFIER)) {
      identifier();
    } else if (match(TokenType.CONSTANT)) {
      consume(TokenType.CONSTANT);
    } else {
      consume(TokenType.LPAREN);
      expression();
      consume(TokenType.RPAREN);
    }
  }

  void identifier() {
    consume(TokenType.IDENTIFIER);
  }

  void args() {
    if (!match(TokenType.RPAREN)) {
      argList();
    }
  }

  void argList() {
    expression();
    if (match(TokenType.COMMA)) {
      consume(TokenType.COMMA);
      argList();
    }
  }

  Token currentToken() {
    return tokens[currentTokenIndex];
  }

  bool match(TokenType expectedType) {
    return currentToken().type == expectedType;
  }

  void consume(TokenType expectedType) {
    if (match(expectedType)) {
      currentTokenIndex++;
    } else if (match(TokenType.DOT) && tokens[currentTokenIndex + 1]?.type == TokenType.DOT) {
      // Consume two consecutive dots
      currentTokenIndex += 2;
    } else {
      throw Exception('Unexpected token: ${currentToken().lexeme}. Expected: $expectedType');
    }
  }
}



