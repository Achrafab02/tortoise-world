enum TokenType {
  // Mots-clés
  IF, ELSE, RETURN, AND, OR,

  // Opérateurs
  EQUAL,

  // Parenthèses et ponctuation
  LPAREN, RPAREN, COLON, COMMA, SEMICOLON, DOT,

  // Identifiants et constantes
  IDENTIFIER, CONSTANT,

  // Fin de fichier
  EOF,
}



class Token {
  final TokenType type;
  final String lexeme;

  Token(this.type, this.lexeme);
}