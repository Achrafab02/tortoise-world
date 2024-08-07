import 'dart:math';

class TortoiseWorld {
  static const int maxDrinkLevel = 100;
  static const int maxHealthLevel = 100;
  static const int maxTime = 5000;
  static const double delayInMs = 1000;

  final List<List<int>> _directionTable = [
    [0, -1],
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, 0],
  ];
  final List<String> _directionTortoiseImageTable = ['tortoise-north', 'tortoise-east', 'tortoise-south', 'tortoise-west'];

  late int? _gridSize;

  final List<List<CellType>> _worldMap = [];
  late int _xPos;
  late int _yPos;
  late int _direction;
  late String _tortoiseImage;
  late int _drinkLevel;
  late int _health;
  late int _eaten;
  late int _lettuceCount;
  late int _score;
  late int _moveCount = 10; // Positive value to force to redraw a new tortoise world at inception

  TortoiseWorld();

  int get eaten => _eaten;

  int get score => _score;

  int get drinkLevel => _drinkLevel;

  int get moveCount => _moveCount;

  String get tortoiseImage => _tortoiseImage;

  int get xPos => _xPos;

  int get yPos => _yPos;

  int get gridSize => _gridSize!;

  void initializeWorldMap(int gridSize) {
    _gridSize = gridSize;
    _xPos = 1;
    _yPos = 1;
    _direction = 1;
    _tortoiseImage = "tortoise-east";
    _drinkLevel = maxDrinkLevel;
    _health = maxHealthLevel;
    _eaten = 0;
    _score = 0;
    _moveCount = 0;

    for (int i = 0; i < gridSize; i++) {
      List<CellType> rows = [];
      for (int j = 0; j < gridSize; j++) {
        rows.add(CellType.ground);
      }
      _worldMap.add(rows);
    }

    int countLettuce = 0;
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
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
    } else if (x == 0 || x == _gridSize! - 1 || y == 0 || y == _gridSize! - 1) {
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

  CellType getCellContent(int x, int y) {
    return _worldMap[y][x];
  }

  MoveResultType moveTortoise(String action) {
    _moveCount++;
    List<int> directionXY = _directionTable[_direction];
    int dx = directionXY[0];
    int dy = directionXY[1];

    CellType ahead = _worldMap[_yPos + dy][_xPos + dx];
    CellType here = _worldMap[_yPos][_xPos];
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
      tortoiseX: _xPos,
      tortoiseY: _yPos,
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
          _worldMap[_yPos][_xPos] = CellType.ground;
          _eaten = _eaten + 1;
        }
        break;
      case 'BOIT':
        if (sensor.isWaterHere) {
          _drinkLevel = maxDrinkLevel;
        }
        break;
      case 'AVANCE':
        if (!sensor.isFreeAhead) {
          _health = _health - 1;
          _drinkLevel = max(_drinkLevel - 2, 0);
        } else {
          _xPos = _xPos + dx;
          _yPos = _yPos + dy;
        }
        break;
    }
    _tortoiseImage = _directionTortoiseImageTable[_direction];
    if (_eaten == _lettuceCount) {
      return MoveResultType.success;
    } else if (_drinkLevel <= 0 || _health <= 0) {
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
    CellType ahead = _worldMap[_yPos + dy][_xPos + dx];
    return ![CellType.stone, CellType.wall].contains(ahead);
  }

  bool isLettuceAhead() {
    List<int> directionXY = _directionTable[_direction];
    int dx = directionXY[0];
    int dy = directionXY[1];

    CellType ahead = _worldMap[_yPos + dy][_xPos + dx];
    return ahead == CellType.lettuce;
  }

  bool isLettuceHere() {
    CellType here = _worldMap[_yPos][_xPos];
    return here == CellType.lettuce;
  }

  bool isWaterAhead() {
    List<int> directionXY = _directionTable[_direction];
    int dx = directionXY[0];
    int dy = directionXY[1];

    CellType ahead = _worldMap[_yPos + dy][_xPos + dx];
    return ahead == CellType.pond;
  }

  bool isWaterHere() {
    CellType here = _worldMap[_yPos][_xPos];
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
