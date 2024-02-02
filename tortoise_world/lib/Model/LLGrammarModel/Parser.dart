import 'Token.dart';

/*
S -> instruction S | ε
instruction -> ifStatement | returnStatement | otherStatement

ifStatement -> 'if' condition ':' S 'else' ':' S

returnStatement -> 'return' expression

otherStatement -> identifier '.' identifier '(' args ')' | return random.choice(args)

condition -> identifier '.' identifier | condition 'and' condition | condition 'or' condition | '(' condition ')'

expression -> identifierOrConstant | expression 'and' expression | expression 'or' expression | '(' expression ')'

identifierOrConstant -> identifier | constant | '(' expression ')'

identifier -> IDENTIFIER

constant -> CONSTANT

functionCall -> identifier '.' identifier '(' args ')'

args -> argList | ε

argList -> expression ',' argList | expression
 */
class Parser {
  final List<Token> tokens;
  int position = 0;

  Parser(this.tokens);

  void parse() {
    parseS();
    if (currentToken.type != TokenType.EOF) {
      print("Erreur syntaxique. Symbole inattendu: ${currentToken.lexeme}");
    } else {
      print("Analyse syntaxique réussie !");
    }
  }

  void parseS() {
    while (currentToken.type != TokenType.EOF) {
      parseInstruction();
    }
  }

  void parseInstruction() {
    if (match(TokenType.IF)) {
      parseCondition();
      expect(TokenType.COLON);
      parseS();
      if (match(TokenType.ELSE)) {
        expect(TokenType.COLON);
        parseS();
      }
    } else if (match(TokenType.RETURN)) {
      parseExpression();
    } else {
      parseOtherStatement();
    }
  }

  void parseCondition() {
    parseExpression();
    while (match(TokenType.AND) || match(TokenType.OR)) {
      parseExpression();
    }
  }

  void parseExpression() {
    parseIdentifierOrConstant();
    while (match(TokenType.AND) || match(TokenType.OR)) {
      parseExpression();
    }
  }

  void parseOtherStatement() {
    expect(TokenType.IDENTIFIER);
    expect(TokenType.EQUAL);
    parseExpression();
    expect(TokenType.SEMICOLON);
  }

  void parseIdentifierOrConstant() {
    if (currentToken.type == TokenType.IDENTIFIER) {
      expect(TokenType.IDENTIFIER);
    } else if (currentToken.type == TokenType.CONSTANT) {
      expect(TokenType.CONSTANT);
    } else {
      expect(TokenType.LPAREN);
      parseExpression();
      expect(TokenType.RPAREN);
    }
  }

  void parseFunctionCall() {
    expect(TokenType.IDENTIFIER);
    expect(TokenType.DOT);
    expect(TokenType.IDENTIFIER);
    expect(TokenType.LPAREN);
    parseArgs();
    expect(TokenType.RPAREN);
  }

  void parseArgs() {
    if (currentToken.type == TokenType.IDENTIFIER || currentToken.type == TokenType.CONSTANT || currentToken.type == TokenType.LPAREN) {
      parseArgList();
    }
  }

  void parseArgList() {
    parseExpression();
    if (match(TokenType.COMMA)) {
      parseArgList();
    }
  }

  Token get currentToken => tokens[position];

  void expect(TokenType expectedType) {
    if (currentToken.type != expectedType) {
      print("Erreur syntaxique. Symbole inattendu: ${currentToken.lexeme}");
    } else {
      position++;
    }
  }

  bool match(TokenType expectedType) {
    if (currentToken.type == expectedType) {
      position++;
      return true;
    }
    return false;
  }
}