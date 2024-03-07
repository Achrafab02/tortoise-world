enum TokenType {
  // Mots-clés
  IF, ELSE, RETURN, AND, OR,

  // Opérateurs
  EQUAL,

  // Parenthèses et ponctuation
  LPAREN, RPAREN, COLON, COMMA, SEMICOLON, DOT, LBRACKET, RBRACKET, LBRACE, RBRACE,

  // Identifiants et constantes
  IDENTIFIER, CONSTANT,

  // Fin de fichier
  EOF, LESS_EQUAL, GREATER_EQUAL, GREATER, LESS, RANDOM,
}



class Token {
  final TokenType type;
  final String lexeme;

  Token(this.type, this.lexeme);
}