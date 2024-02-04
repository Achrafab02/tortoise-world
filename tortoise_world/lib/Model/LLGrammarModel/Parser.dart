import 'Token.dart';

class Parser {
  final List<Token> tokens;
  int currentTokenIndex = 0;

  Parser(this.tokens);

  Token get currentToken => tokens[currentTokenIndex];

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
      throw Exception('Syntax error');
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
        throw Exception('Syntax error: expected colon after condition');
      }
      S();
      if (match(TokenType.ELSE)) {
        if (match(TokenType.IF)) {
          condition();
          if (!match(TokenType.COLON)) {
            throw Exception('Syntax error: expected colon after condition');
          }
          S();
        } else {
          if (!match(TokenType.COLON)) {
            throw Exception('Syntax error: expected colon after else');
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
      if (!match(TokenType.IDENTIFIER)) {
        throw Exception('Syntax error: expected identifier after dot');
      }
    }
  } else if (match(TokenType.LPAREN)) {
    condition();
    if (!match(TokenType.RPAREN)) {
      throw Exception('Syntax error: expected right parenthesis');
    }
  } else if (match(TokenType.LBRACKET)) {
    expression();
    if (!match(TokenType.RBRACKET)) {
      throw Exception('Syntax error: expected right bracket');
    }
  } else {
    condition();
  }

  if (match(TokenType.AND) || match(TokenType.OR)) {
    condition();
  }

  if (match(TokenType.LESS) || match(TokenType.LESS_EQUAL) || match(TokenType.GREATER) || match(TokenType.GREATER_EQUAL) || match(TokenType.EQUAL)) {
    identifierOrConstant();
  }

  if (match(TokenType.DOT)) {
    if (!match(TokenType.IDENTIFIER)) {
      throw Exception('Syntax error: expected identifier after dot');
    }
  }
}

  void otherStatement() {
    if (match(TokenType.IDENTIFIER)) {
      if (match(TokenType.DOT)) {
        if (!match(TokenType.IDENTIFIER)) {
          throw Exception('Syntax error: expected identifier after dot');
        }
        if (!match(TokenType.LPAREN)) {
          throw Exception('Syntax error: expected left parenthesis after identifier');
        }
        args();
        if (!match(TokenType.RPAREN)) {
          throw Exception('Syntax error: expected right parenthesis after arguments');
        }
      }
    } else if (match(TokenType.RETURN)) {
      args();
    } else {
      if (match(TokenType.ELSE)) {
        if (match(TokenType.IF)) {
          condition();
          if (!match(TokenType.COLON)) {
            throw Exception('Syntax error: expected colon after condition');
          }
          S();
        } else {
          if (!match(TokenType.COLON)) {
            throw Exception('Syntax error: expected colon after else');
          }
          S();
        }
      } else {

      }
    }
  }

  void args() {
    if (currentToken.type == TokenType.IDENTIFIER ||
        currentToken.type == TokenType.CONSTANT ||
        currentToken.type == TokenType.LPAREN) {
      argList();
    }
  }

  void argList() {
    expression();
    if (match(TokenType.COMMA)) {
      argList();
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
        if (!match(TokenType.IDENTIFIER)) {
          throw Exception('Syntax error: expected identifier after dot');
        }
        if (match(TokenType.LPAREN) || match(TokenType.LBRACKET)) {
          arguments();
        }
      }
    } else if (match(TokenType.CONSTANT)) {
      return;
    } else if (match(TokenType.LPAREN)) {
      expression();
      if (!match(TokenType.RPAREN)) {
        throw Exception('Syntax error: expected right parenthesis');
      }
    }
  }

  void arguments() {
    if (match(TokenType.LPAREN)) {
      argList();
      if (!match(TokenType.RPAREN)) {
        throw Exception('Syntax error: expected right parenthesis');
      }
    } else if (match(TokenType.LBRACKET)) {
      argList();
      if (!match(TokenType.RBRACKET)) {
        throw Exception('Syntax error: expected right bracket');
      }
    }
  }

}
