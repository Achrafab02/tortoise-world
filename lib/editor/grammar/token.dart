enum TokenType {
  // Keywords
  IF,
  RETURN,
  AND,
  OR,

  // Operators
  EQUAL,

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

  // Relational operators
  LESS_EQUAL,
  GREATER_EQUAL,
  GREATER,
  LESS,

  // Others
  EOF,

  RANDOM,
  CHOICE,
  SENSOR,
  FREE_AHEAD,
  LETTUCE_HERE,
  LETTUCE_AHEAD,
  WATER_AHEAD,
  WATER_HERE,
  DRINK_LEVEL
}

class Token {
  final TokenType type;
  final String lexeme;

  Token(this.type, this.lexeme);
}
