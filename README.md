# Intelligence Artificielle - L'agent tortue

## Règles du jeu

Une tortue évolue dans un environnement formé de laitues, de pierres et d'un chien. Le but de la tortue est de manger toutes les salades qui se trouvent dans son environnement. Malheureusement, la tortue ne peut voir que la case qui se trouve directement devant elle. De plus, le chien, très joueur, peut venir perturber la tortue et lui faire perdre des points de santé.

La tortue dispose de 100 points de santé et de 100 points de boisson au début du jeu. Le jeu se termine dès que la tortue a mangé toutes les salades ou qu'elle meurt à cause de son niveau de santé ou de boisson.

Tous les déplacements vers l'avant (ie. 'forward') consomment 2 unités de boisson, et les autres actions consomment une unité de boisson. Quand la tortue boit de l'eau, son niveau de boisson remonte à 100. Par contre, il n'y a aucun moyen d'augmenter ses points de santé.

Plus le niveau de boisson est bas, moins la tortue réagit. Ainsi, chaque action consomme une unité de temps quand le niveau de boisson est à 100, mais consomme jusqu'à 4 unités de temps quand il est proche de 0.

Chaque collision avec le chien coûte 5 points de santé et chaque collision avec un obstacle coûte un point de santé.

## Les capteurs

La tortue perçoit la case qui se trouve devant elle grâce à ses capteurs dont les valeurs peuvent être obtenues par les commandes :
- `capteur.libre_devant` – retourne vrai s'il n'y a aucun rocher ou mur dans la case en face de celle de la tortue.
- `capteur.laitue_devant` – retourne vrai s'il y a une laitue dans la case en face de celle de la tortue.
- `capteur.laitue_ici` – retourne vrai s'il y a une laitue dans la case où se trouve la tortue.
- `capteur.eau_devant` – retourne vrai s'il y a de l'eau dans la case en face de celle de la tortue.
- `capteur.eau_ici` – retourne vrai s'il y a de l'eau dans la case où se trouve la tortue.
- `capteur.niveau_boisson` – retourne le niveau de boisson de la tortue ; une valeur entière entre 0 et 100.

De plus, elle peut aussi savoir où se trouve le chien grâce aux deux commandes :
- `capteur.chien_devant` – retourne le nombre de cases en face ou derrière la tortue. Ce peut donc être une valeur positive si le chien est devant ou une valeur négative si le chien est derrière.
- `capteur.chien_droite` – retourne le nombre de cases à droite ou à gauche de la tortue. Ce peut donc être une valeur positive si le chien est à droite ou une valeur négative si le chien est à gauche.

## Les actions

À chaque tour, la tortue peut effectuer l'une des cinq actions possibles :
- `MANGE` – la tortue mange la laitue si une laitue se trouve dans la même case que l'agent.
- `BOIT` – la tortue boit de l'eau si elle se trouve dans une case où il y a de l'eau.
- `GAUCHE` – la tortue tourne de 90 degrés vers sa gauche.
- `DROITE` – la tortue tourne de 90 degrés vers sa droite.
- `AVANCE` – la tortue avance si cela est possible.

## Exemples d'instructions Python

```python
if capteur.libre_devant:
    return AVANCE
else:
    return DROITE

if capteur.chien_devant < 10:
    return GAUCHE

if (abs(capteur.chien_devant) < 3 and abs(capteur.chien_droite) < 3):
    return GAUCHE
