# LL(1) Grammar

```
  pg : instruction pg
     | ε
     
  instruction : if_instruction
              | return_instruction
                       
  return_instruction : RETURN CONSTANT
                     | RETURN RANDOM array
                   
  array : [ argList ]
  
  arg_list : CONSTANT
           | CONSTANT COMA arg_list
          
  if_instruction : IF condition COLON instruction
  
  condition : LPAREN condition RPAREN
            | simple_condition AND condition
            | simple_condition OR condition
            | NOT simple_bondition
                      
  simple_ondition : sensor
                   | DRINK_LEVEL RELATION_OPERATOR INTEGER

  sensor: SENSOR DOT VALUE
```

# Exemples d'instructions possibles

```
    return AVANCE
    return random.choice([AVANCE, DROITE, GAUCHE])
    if capteur.laitue_devant: return AVANCE
    if capteur.niveau_boisson < 70: return BOIT
    if capteur.laitue_ici: return MANGE
    if capteur.eau_ici and capteur.niveau_boisson < 70: return BOIT
    if (capteur.eau_ici and capteur.niveau_boisson < 70 and capteur.libre_devant): return BOIT
    if not capteur.libre_devant: return random.choice([AVANCE, DROITE, GAUCHE])
```
