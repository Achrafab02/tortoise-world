# LL(1) Grammar

```
pg -> instr pg | ε 
{  }

instr -> IF condition COLON return | return | otherStatement

return -> RETURN ACTION
{ return.action = ACTION; }

condition -> (IDENTIFIER DOT IDENTIFIER | LPAREN condition RPAREN | LBRACKET expression RBRACKET) (AND condition)? (OR condition)? (LESS | LESS_EQUAL | GREATER | GREATER_EQUAL | EQUAL) identifierOrConstant (DOT IDENTIFIER)?
 { test condition }
 
otherStatement -> IDENTIFIER (DOT IDENTIFIER LPAREN args RPAREN)?
  | RETURN args
  | ELSE (IF condition COLON S | COLON S)?

args -> argList | CONSTANT

argList -> expression (COMMA argList | RPAREN | RBRACKET)

expression -> identifierOrConstant AND expression | identifierOrConstant

identifierOrConstant -> IDENTIFIER (DOT IDENTIFIER (LPAREN | LBRACKET)?)? | CONSTANT | LPAREN expression RPAREN

arguments -> LPAREN argList RPAREN | LBRACKET argList (RBRACKET | RPAREN)
```