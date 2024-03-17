import 'dart:math';
import 'package:tortoise_world/Model/LLGrammarModel/Parser.dart';
import '../Presenter/LLGrammarPresenter/GrammarPresenter.dart';
import '../View/utils.dart';
import 'LLGrammarModel/Token.dart';

class TortoiseBrain {
  late Parser parser;

  void setParser(Parser parser) {
    this.parser = parser;
  }

  

}



class Tortoise {
  bool update_current_place = false;
  int direction=1;
  List<List<int>> directionTable = [
    [0, -1],
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, 0],
  ];
  int xpos=1;
  int ypos=1;
  List<List<String>> worldMap = [];
  late String tortoiseImage;
  List<String> directionTortoiseImageTable = ['tortoise-n', 'tortoise-e', 'tortoise-s', 'tortoise-w'];
  int drinkLevel=MAX_DRINK;
  int health=MAX_HEALTH;
  bool pain=false;
  int eaten=0;
  late int lettuceCount;
  int score=0;
  bool win=false;
  String action='none';
  int moveCount=0;


  Tortoise({required List<List<String>> worldMap}) {
    this.worldMap = worldMap;
  }

  String think(Map<String, List<String>> _data) {
    if (_data.containsKey('laitue_ici') && _data['laitue_ici']!.isNotEmpty && getlaitue_ici()) {
      return _data['laitue_ici']![0];
    } else if (_data.containsKey('laitue_devant') && _data['laitue_devant']!.isNotEmpty && getlaitue_devant()) {
      return _data['laitue_devant']![0];
    } else if (_data.containsKey('libre_devant') && _data['libre_devant']!.isNotEmpty && getlibre_devant()) {
      return _data['libre_devant']![0];
    } else if (_data.containsKey('eau_devant') && _data['eau_devant']!.isNotEmpty && geteau_devant()) {
      return _data['eau_devant']![0];
    } else if (_data.containsKey('eau_ici') && _data['eau_ici']!.isNotEmpty && geteau_ici()) {
      return _data['eau_ici']![0];
    } else if (_data.containsKey('choise') && _data['choise']!.isNotEmpty) {
        // return random.choise(_data['choise']);
      var random = Random(DateTime.now().millisecondsSinceEpoch);
      return _data['choise']![random.nextInt(_data['choise']!.length)];
    } else if (_data['else']!.isNotEmpty && _data['else']!.length > (_data.keys.length - 2)) {
      return _data['else']!.last;
    }
    return 'none';
  }
  
  bool getlibre_devant() {
    List<int> directionXY= directionTable[direction];
    int dx = directionXY[0];
    int dy = directionXY[1];

    String ahead =worldMap[ypos + dy][xpos + dx];
    bool freeAhead = !['stone', 'wall'].contains(ahead);
    return freeAhead;
  }

  bool getlaitue_devant() {
    List<int> directionXY= directionTable[direction];
    int dx = directionXY[0];
    int dy = directionXY[1];

    String ahead =worldMap[ypos + dy][xpos + dx];
    bool lettuceAhead = ahead == 'lettuce';
    return lettuceAhead;
  }

  bool getlaitue_ici() {
    String here = worldMap[ypos][xpos];
    bool lettuceHere = here == 'lettuce';
    return lettuceHere;
  }

  bool geteau_devant() {
    List<int> directionXY= directionTable[direction];
    int dx = directionXY[0];
    int dy = directionXY[1];

    String ahead =worldMap[ypos + dy][xpos + dx];
    bool waterAhead = ahead == 'pond';
    return waterAhead;
  }

  bool geteau_ici() {
    String here = worldMap[ypos][xpos];
    bool waterHere = here == 'pond';
    return waterHere;
  }

  int getniveau_boisson() {
    return drinkLevel;
  }

  int gettortoiseX() {
    return xpos;
  }

  int gettortoiseY() {
    return ypos;
  }

  int gettortoiseDirection() {
    return direction;
  }


  void updateLettuceCount(int count) {
    lettuceCount = count;
  }

  void moveTortoise(String action) {
    moveCount++;
    List<int> directionXY= directionTable[direction];
    int dx = directionXY[0];
    int dy = directionXY[1];

    String ahead =worldMap[ypos + dy][xpos + dx];
    String here = worldMap[ypos][xpos];
    bool freeAhead = !['stone', 'wall'].contains(ahead);
    bool lettuceAhead = ahead == 'lettuce';
    bool lettuceHere = here == 'lettuce';
    bool waterAhead = ahead == 'pond';
    bool waterHere = here == 'pond';

    var sensors = {
      'libre_devant': freeAhead,
      'laitue_devant': lettuceAhead,
      'laitue_ici': lettuceHere,
      'eau_devant': waterAhead,
      'eau_ici': waterHere,
    };

    Sensor sensor = Sensor(
      libre_devant: freeAhead,
      laitue_devant: lettuceAhead,
      laitue_ici: lettuceHere,
      eau_devant: waterAhead,
      eau_ici: waterHere,
      niveau_boisson: drinkLevel,
      tortoiseX: xpos,
      tortoiseY: ypos,
      tortoiseDirection: direction,
    );

    print(action);
    switch (action) {
      case 'GAUCHE':
        direction = (direction - 1) % 4;
        drinkLevel=max(drinkLevel-1, 0);


        break;
      case 'DROITE':
        direction = (direction + 1) % 4;
        drinkLevel=max(drinkLevel-1, 0);


        break;
      case 'MANGE':
        if (sensor.laitue_ici) {
          worldMap[ypos][xpos] = 'ground';
          eaten=eaten+1;
        }
        break;
      case 'BOIT':
        if (sensor.eau_ici) {
          drinkLevel = MAX_DRINK;
        }
        break;

      case 'AVANCE':
        xpos = xpos + dx;
        ypos = ypos + dy;
        if (!sensor.libre_devant) {
          health=health-1;
          pain=true;
          drinkLevel=max(drinkLevel-2, 0);
        }
        break;

    }
    tortoiseImage = directionTortoiseImageTable[direction];
    if(eaten==lettuceCount){
      print("Vous avez gagné!");
      action="stop";
      win=true;

    }
    else if (drinkLevel<=0 || health<=0){
      win =false;
      if (drinkLevel<=0){
        print("Vous êtes mort de soif!");
      }
      else{
        print("Vous êtes mort de faim!");

      }
      action="stop";
      pain =true;

    }
    int score = eaten * 10 - moveCount ~/ 10;
  }


}


class Sensor {
  bool libre_devant;
  bool laitue_devant;
  bool laitue_ici;
  bool eau_devant;
  bool eau_ici;
  int niveau_boisson;
  int tortoiseX;
  int tortoiseY;
  int tortoiseDirection;

  Sensor({
    required this.libre_devant,
    required this.laitue_devant,
    required this.laitue_ici,
    required this.eau_devant,
    required this.eau_ici,
    required this.niveau_boisson,
    required this.tortoiseX,
    required this.tortoiseY,
    required this.tortoiseDirection,
  });
}
