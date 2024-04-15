# Tortoise World

## Règles du jeu

L'objectif de ce projet est de proposer une cadre ludique pour l'apprentissage de la programmation
en lui fournissant des instructions pour utiliser efficacement les commandes, les conditions et les boucles.

Le protagoniste du jeu est une tortue équipée de capteurs lui permettant de regarder droit devant.
La tortue peut avancer, manger des feuilles de laitue et boire de l'eau en évitant les pierres.
Chaque action effectuée par la tortue contribue à l'évolution d'un score.
Le but ultime du joueur est d'obtenir le meilleur score possible en écrivant un programme dans
un langage qui est un sous-ensemble du Python.

Le joueur doit programmer la tortue pour qu'elle se déplace de manière stratégique, prenne des décisions
basées sur des conditions et utilise des boucles pour optimiser ses actions.
Chaque mouvement, chaque interaction avec la laitue et l'eau influence le score total du joueur.
L'objectif final est d'élaborer un code efficace et astucieux permettant à la tortue d'accomplir
des actions intelligentes et ainsi d'atteindre le meilleur score possible.
En résumé, le jeu vise à rendre l'apprentissage de la programmation ludique et interactif, tout en mettant
en avant la logique algorithmique et la créativité des joueurs.

## Les auteurs (promotion 2025)

Achraf ABOULAKJAM
Tawfik MAMAI
Hamid BEN OMAR
Nada NSIRI

## Les capteurs

La tortue perçoit la case qui se trouve devant elle grâce à ses capteurs
dont les valeurs peuvent être obtenues par les variables :

- `capteur.libre_devant` – retourne vrai s'il n'y a aucun rocher ou mur dans la case en face de celle de la tortue.
- `capteur.laitue_devant` – retourne vrai s'il y a une laitue dans la case en face de celle de la tortue.
- `capteur.laitue_ici` – retourne vrai s'il y a une laitue dans la case où se trouve la tortue.
- `capteur.eau_devant` – retourne vrai s'il y a de l'eau dans la case en face de celle de la tortue.
- `capteur.eau_ici` – retourne vrai s'il y a de l'eau dans la case où se trouve la tortue.
- `capteur.niveau_boisson` – retourne le niveau de boisson de la tortue ; une valeur entière entre 0 et 100.

## Les actions

À chaque tour, la tortue peut effectuer l'une des cinq actions possibles :

- `MANGE` – la tortue mange la laitue si une laitue se trouve dans la même case que l'agent.
- `BOIT` – la tortue boit de l'eau si elle se trouve dans une case où il y a de l'eau.
- `GAUCHE` – la tortue tourne de 90 degrés vers sa gauche.
- `DROITE` – la tortue tourne de 90 degrés vers sa droite.
- `AVANCE` – la tortue avance si cela est possible.

## Exemples d'instructions du langage

```python
if capteur.libre_devant: return AVANCE
return random.choice([DROITE, GAUCHE])
```
