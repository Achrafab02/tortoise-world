enum TokenType {
  // Keywords
  IF,
  RETURN,
  AND,
  OR,
  NOT,

  // Punctuation and Parenthesis
  LPAREN,
  RPAREN,
  COLON,
  COMMA,
  SEMICOLON,
  DOT,
  LBRACKET,
  RBRACKET,

  // Identifiers and constants
  IDENTIFIER,
  CONSTANT,
  INTEGER,

  // Relational operators
  LESS_EQUAL,
  GREATER_EQUAL,
  GREATER,
  LESS,
  EQUAL,
  NOT_EQUAL,

  // Others
  EOF,
  RANDOM,

  // Constants
  FREE_AHEAD,
  LETTUCE_HERE,
  LETTUCE_AHEAD,
  WATER_AHEAD,
  WATER_HERE,
  DRINK_LEVEL,
  FORWARD,
  LEFT,
  RIGHT,
  EAT,
  DRINK
}

class Token {
  final TokenType type;
  final String lexeme;

  Token(this.type, this.lexeme);
}
