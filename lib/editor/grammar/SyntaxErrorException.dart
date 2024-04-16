class SyntaxErrorException implements Exception {
  final int line;
  final String message;

  SyntaxErrorException(this.line, this.message);
}
