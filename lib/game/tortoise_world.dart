import 'dart:math';

class TortoiseWorld {
  // TODO pouvoir changer la taille du tableau (avec un taille maximum)
  static const int maxDrinkLevel = 100;
  static const int maxHealthLevel = 100;
  static const int maxTime = 5000;
  static const double delayInMs = 1000;

  final int rows = 12;
  final int columns = 12;
  int _direction = 1;
  final List<List<int>> _directionTable = [
    [0, -1],
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, 0],
  ];
  int _xpos = 1;
  int _ypos = 1;
  final List<List<CellType>> _worldMap = [];
  late String _tortoiseImage = "tortoise-east";
  final List<String> _directionTortoiseImageTable = ['tortoise-north', 'tortoise-east', 'tortoise-south', 'tortoise-west'];
  int _drinkLevel = maxDrinkLevel;
  int _health = maxHealthLevel;
  int _eaten = 0;
  late int _lettuceCount;
  int _score = 0;
  bool _win = false;
  int _moveCount = 0;

  TortoiseWorld();

  int get eaten => _eaten;

  int get score => _score;

  int get drinkLevel => _drinkLevel;

  int get moveCount => _moveCount;

  get tortoiseImage => _tortoiseImage;

  get xpos => _xpos;

  get ypos => _ypos;

  void initializeWorldMap() {
    for (int i = 0; i < rows; i++) {
      List<CellType> rows = [];
      for (int j = 0; j < columns; j++) {
        rows.add(CellType.ground);
      }
      _worldMap.add(rows);
    }

    int countLettuce = 0;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        CellType type = _selectTileType(j, i);
        _worldMap[i][j] = type;
        if (type == CellType.lettuce) {
          countLettuce++;
        }
      }
    }
    _lettuceCount = countLettuce;
  }

  CellType _selectTileType(int x, int y) {
    if (x == 1 && y == 1) {
      return CellType.pond;
    } else if (x == 0 || x == columns - 1 || y == 0 || y == rows - 1) {
      return CellType.wall;
    } else {
      double stoneProbability = 0.1;
      double lettuceProbability = 0.2;
      double pondProbability = 0.1;

      double randomValue = Random().nextDouble();

      CellType overlayImage = CellType.ground;

      if (randomValue < stoneProbability) {
        overlayImage = CellType.stone;
      } else if (randomValue < stoneProbability + lettuceProbability) {
        overlayImage = CellType.lettuce;
      } else if (randomValue < stoneProbability + lettuceProbability + pondProbability) {
        overlayImage = CellType.pond;
      }

      return overlayImage;
    }
  }

  CellType getCellContent(int x, int y) => _worldMap[y][x];

  MoveResultType moveTortoise(String action) {
    _moveCount++;
    List<int> directionXY = _directionTable[_direction];
    int dx = directionXY[0];
    int dy = directionXY[1];

    CellType ahead = _worldMap[_ypos + dy][_xpos + dx];
    CellType here = _worldMap[_ypos][_xpos];
    bool freeAhead = ![CellType.stone, CellType.wall].contains(ahead);
    bool lettuceAhead = ahead == CellType.lettuce;
    bool lettuceHere = here == CellType.lettuce;
    bool waterAhead = ahead == CellType.pond;
    bool waterHere = here == CellType.pond;

    Sensor sensor = Sensor(
      isFreeAhead: freeAhead,
      isLettuceAhead: lettuceAhead,
      isLettuceHere: lettuceHere,
      isWaterAhead: waterAhead,
      isWaterHere: waterHere,
      drinkLevel: _drinkLevel,
      tortoiseX: _xpos,
      tortoiseY: _ypos,
      tortoiseDirection: _direction,
    );
    switch (action) {
      case 'GAUCHE':
        _direction = (_direction - 1) % 4;
        _drinkLevel = max(_drinkLevel - 1, 0);
        break;
      case 'DROITE':
        _direction = (_direction + 1) % 4;
        _drinkLevel = max(_drinkLevel - 1, 0);
        break;
      case 'MANGE':
        if (sensor.isLettuceHere) {
          _worldMap[_ypos][_xpos] = CellType.ground;
          _eaten = _eaten + 1;
        }
        break;
      case 'BOIT':
        if (sensor.isWaterHere) {
          _drinkLevel = maxDrinkLevel;
        }
        break;
      case 'AVANCE':
        // TODO pourquoi Wall n'est pas pris en compte ?
        if (!sensor.isFreeAhead) {
          _health = _health - 1;
          _drinkLevel = max(_drinkLevel - 2, 0);
        } else {
          _xpos = _xpos + dx;
          _ypos = _ypos + dy;
        }
        break;
    }
    _tortoiseImage = _directionTortoiseImageTable[_direction];
    if (_eaten == _lettuceCount) {
      action = "stop"; // TODO plus utile si success est pris en compte dans update()
      _win = true;
      return MoveResultType.success;
    } else if (_drinkLevel <= 0 || _health <= 0) {
      _win = false;
      if (_drinkLevel <= 0) {
        return MoveResultType.diedOfThirsty;
      } else {
        return MoveResultType.diedOfHunger;
      }
    }
    _score = _eaten * 10 - _moveCount ~/ 10;
    return MoveResultType.ok;
  }

  bool isFreeAhead() {
    List<int> directionXY = _directionTable[_direction];
    int dx = directionXY[0];
    int dy = directionXY[1];
    CellType ahead = _worldMap[_ypos + dy][_xpos + dx];
    return ![CellType.stone, CellType.wall].contains(ahead);
  }

  bool isLettuceAhead() {
    List<int> directionXY = _directionTable[_direction];
    int dx = directionXY[0];
    int dy = directionXY[1];

    CellType ahead = _worldMap[_ypos + dy][_xpos + dx];
    return ahead == CellType.lettuce;
  }

  bool isLettuceHere() {
    CellType here = _worldMap[_ypos][_xpos];
    return here == CellType.lettuce;
  }

  bool isWaterAhead() {
    List<int> directionXY = _directionTable[_direction];
    int dx = directionXY[0];
    int dy = directionXY[1];

    CellType ahead = _worldMap[_ypos + dy][_xpos + dx];
    return ahead == CellType.pond;
  }

  bool isWaterHere() {
    CellType here = _worldMap[_ypos][_xpos];
    return here == CellType.pond;
  }
}

class Sensor {
  bool isFreeAhead;
  bool isLettuceAhead;
  bool isLettuceHere;
  bool isWaterAhead;
  bool isWaterHere;
  int drinkLevel;
  int tortoiseX;
  int tortoiseY;
  int tortoiseDirection;

  Sensor({
    required this.isFreeAhead,
    required this.isLettuceAhead,
    required this.isLettuceHere,
    required this.isWaterAhead,
    required this.isWaterHere,
    required this.drinkLevel,
    required this.tortoiseX,
    required this.tortoiseY,
    required this.tortoiseDirection,
  });
}

enum CellType {
  ground,
  lettuce,
  pond,
  wall,
  stone,
}

enum MoveResultType { success, diedOfThirsty, diedOfHunger, ok }
