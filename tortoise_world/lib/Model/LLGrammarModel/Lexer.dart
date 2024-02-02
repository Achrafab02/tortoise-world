import 'Token.dart';
class Lexer {
  final String input;
  int position = 0;

  Lexer(this.input);

  Token getNextToken() {
    if (position >= input.length) {
      return Token(TokenType.EOF, '');
    }

    var currentChar = input[position];

    // Mots-clés
    if (currentChar == 'i' && matchKeyword('if')) {
      return Token(TokenType.IF, 'if');
    } else if (currentChar == 'e' && matchKeyword('else')) {
      return Token(TokenType.ELSE, 'else');
    } else if (currentChar == 'r' && matchKeyword('return')) {
      return Token(TokenType.RETURN, 'return');
    } else if (currentChar == 'a' && matchKeyword('and')) {
      return Token(TokenType.AND, 'and');
    } else if (currentChar == 'o' && matchKeyword('or')) {
      return Token(TokenType.OR, 'or');
    }

    if (currentChar == '=') {
      position++;
      return Token(TokenType.EQUAL, '=');
    }

    // Parenthèses et ponctuation
    switch (currentChar) {
      case '(':
        position++;
        return Token(TokenType.LPAREN, '(');
      case ')':
        position++;
        return Token(TokenType.RPAREN, ')');
      case ':':
        position++;
        return Token(TokenType.COLON, ':');
      case ',':
        position++;
        return Token(TokenType.COMMA, ',');
      case ';':
        position++;
        return Token(TokenType.SEMICOLON, ';');
      case '.':
        position++;
        return Token(TokenType.DOT, '.');
    }

    // Identifiants et constantes
    if (isAlpha(currentChar)) {
      var lexeme = consumeWhile(isAlphaNumeric);
      return Token(TokenType.IDENTIFIER, lexeme);
    } else if (isDigit(currentChar)) {
      var lexeme = consumeWhile(isDigit);
      return Token(TokenType.CONSTANT, lexeme);
    }

    // Caractère non reconnu
    position++;
    return Token(TokenType.EOF, '');
  }

  bool matchKeyword(String keyword) {
    for (var i = 0; i < keyword.length; i++) {
      if (position + i >= input.length || input[position + i] != keyword[i]) {
        return false;
      }
    }
    position += keyword.length;
    return true;
  }

  String consumeWhile(bool Function(String) condition) {
    var result = '';
    while (position < input.length && condition(input[position])) {
      result += input[position];
      position++;
    }
    return result;
  }

  bool isAlpha(String char) =>
      (char.compareTo('a') >= 0 && char.compareTo('z') <= 0) ||
          (char.compareTo('A') >= 0 && char.compareTo('Z') <= 0) ||
          char == '_';


  bool isDigit(String char) => char.compareTo('0') >= 0 && char.compareTo('9') <= 0;

  bool isAlphaNumeric(String char) => isAlpha(char) || isDigit(char);
}