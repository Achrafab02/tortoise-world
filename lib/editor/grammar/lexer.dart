import 'token.dart';

class Lexer {
  final String _input;
  int _position = 0;

  Lexer(this._input);

  // TODO Les tests unitaires pour toutes ces méthodces
  Token getNextToken() {
    _skipWhitespace();
    if (_position >= _input.length) {
      return Token(TokenType.EOF, '');
    }
    var currentChar = _input[_position];

    // keywords
    if (currentChar == 'i' && _matchKeyword('if')) {
      return Token(TokenType.IF, 'if');
    } else if (currentChar == 'r' && _matchKeyword('return')) {
      return Token(TokenType.RETURN, 'return');
    } else if (currentChar == 'n' && _matchKeyword('not')) {
      return Token(TokenType.NOT, 'not');
    } else if (currentChar == 'a' && _matchKeyword('and')) {
      return Token(TokenType.AND, 'and');
    } else if (currentChar == 'o' && _matchKeyword('or')) {
      return Token(TokenType.OR, 'or');
    } else if (currentChar == 'r' && _matchKeyword('random.choice')) {
      return Token(TokenType.RANDOM, 'random.choice');
    } else if (currentChar == 'c' && _matchKeyword('capteur.libre_devant')) {
      return Token(TokenType.FREE_AHEAD, 'capteur.libre_devant');
    } else if (currentChar == 'c' && _matchKeyword('capteur.laitue_devant')) {
      return Token(TokenType.LETTUCE_AHEAD, 'capteur.laitue_devant');
    } else if (currentChar == 'c' && _matchKeyword('capteur.laitue_ici')) {
      return Token(TokenType.LETTUCE_HERE, 'capteur.laitue_ici');
    } else if (currentChar == 'c' && _matchKeyword('capteur.eau_devant')) {
      return Token(TokenType.WATER_AHEAD, 'capteur.eau_devant');
    } else if (currentChar == 'c' && _matchKeyword('capteur.eau_ici')) {
      return Token(TokenType.WATER_HERE, 'capteur.eau_ici');
    } else if (currentChar == 'c' && _matchKeyword('capteur.niveau_boisson')) {
      return Token(TokenType.DRINK_LEVEL, 'capteur.niveau_boisson');
    } else if (currentChar == 'A' && _matchKeyword('AVANCE')) {
      return Token(TokenType.FORWARD, 'AVANCE');
    } else if (currentChar == 'D' && _matchKeyword('DROITE')) {
      return Token(TokenType.RIGHT, 'DROITE');
    } else if (currentChar == 'G' && _matchKeyword('GAUCHE')) {
      return Token(TokenType.LEFT, 'GAUCHE');
    } else if (currentChar == 'B' && _matchKeyword('BOIT')) {
      return Token(TokenType.DRINK, 'BOIT');
    } else if (currentChar == 'M' && _matchKeyword('MANGE')) {
      return Token(TokenType.EAT, 'MANGE');
    }

    // Logical operators
    if (currentChar == '=' && _input[_position + 1] == '=') {
      _position += 2;
      return Token(TokenType.EQUAL, '==');
    }

    if (currentChar == '<' && _input[_position + 1] == '=') {
      _position += 2;
      return Token(TokenType.LESS_EQUAL, '<=');
    }

    if (currentChar == '<') {
      _position++;
      return Token(TokenType.LESS, '<');
    }

    if (currentChar == '>' && _input[_position + 1] == '=') {
      _position += 2;
      return Token(TokenType.GREATER_EQUAL, '>=');
    }

    if (currentChar == '>') {
      _position++;
      return Token(TokenType.GREATER, '>');
    }

    // Punctuation and parenthesis
    switch (currentChar) {
      case '(':
        _position++;
        return Token(TokenType.LPAREN, '(');
      case '[':
        _position++;
        return Token(TokenType.LBRACKET, '[');
      case ']':
        _position++;
        return Token(TokenType.RBRACKET, ']');
      case ')':
        _position++;
        return Token(TokenType.RPAREN, ')');
      case ':':
        _position = _position + 2;
        return Token(TokenType.COLON, ':');
      case ',':
        _position++;
        return Token(TokenType.COMMA, ',');
      case ';':
        _position++;
        return Token(TokenType.SEMICOLON, ';');
      case '.':
        _position++;
        return Token(TokenType.DOT, '.');
    }

    // Identifiers et constants
    if (_isDigit(currentChar)) {
      var lexeme = _consumeWhile(_isDigit);
      return Token(TokenType.INTEGER, lexeme);
    } else if (_isAlpha(currentChar)) {
      var lexeme = _consumeWhile(_isAlphaNumeric);
      return Token(TokenType.IDENTIFIER, lexeme);
    } else if (_isConstant(currentChar)) {
      // TODO utile maintenant ?
      var lexeme = _consumeWhile(_isConstant);
      return Token(TokenType.CONSTANT, lexeme);
    }

    // Unknown characters
    _position++;
    return Token(TokenType.EOF, '');
  }

  void _skipWhitespace() {
    while (_position < _input.length && _input[_position] == ' ') {
      _position++;
    }
  }

  bool _matchKeyword(String keyword) {
    for (var i = 0; i < keyword.length; i++) {
      if (_position + i >= _input.length || _input[_position + i] != keyword[i]) {
        return false;
      }
    }
    _position += keyword.length;
    return true;
  }

  String _consumeWhile(bool Function(String) condition) {
    var result = '';
    while (_position < _input.length && condition(_input[_position])) {
      result += _input[_position];
      _position++;
    }
    return result;
  }

  bool _isConstant(String char) => char.compareTo('A') >= 0 && char.compareTo('Z') <= 0;

  bool _isAlpha(String char) => (char.compareTo('a') >= 0 && char.compareTo('z') <= 0) || char == '_';

  bool _isDigit(String char) => char.compareTo('0') >= 0 && char.compareTo('9') <= 0;

  bool _isAlphaNumeric(String char) => _isAlpha(char) || _isDigit(char);

  List<Token> tokenizeCode() {
    var token = <Token>[];
    while (true) {
      token.add(getNextToken());
      if (token.last.type == TokenType.EOF) {
        break;
      }
    }
    return token;
  }
}
