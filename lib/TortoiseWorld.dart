import 'dart:math';

class TortoiseWorld {
  static const int LETTUCE_PROBABILITY = 6;
  static const int WATER_PROBABILITY = 20;
  static const int STONE_PROBABILITY = 10;
  static const int MAX_DRINK = 100;
  static const int MAX_HEALTH = 100;
  static const int MAX_TIME = 5000;

  int xpos = 1;
  int ypos = 1;
  int drinkLevel = 0;
  int eaten = 0;
  double currentTime = 0.0;
  int direction = 0; // north = 0, east = 1, south = 2, west = 3
  String action = 'None';
  double nextTortoiseTime = 0;
  bool updateCurrentPlace = false;
  int score = 0;
  int health = MAX_HEALTH;
  bool pain = false;
  int lettuceCount = 0;
  int grid_size = 0;
  int get gridSize => grid_size;
  List<List<String>> worldmap = [[]];

  List<List<int>> directionTable = [
    [0, -1],
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, 0],
  ];

  bool win = false;

  TortoiseWorld(int grid_size) {
    drinkLevel = MAX_DRINK;
    createWorldMap(grid_size);
    this.grid_size = grid_size;
    health = MAX_HEALTH;
    pain = false;
    win = false;
  }

  String think(String sensor) {
    return 'forward';
  }
  /*void stepTortoise() {
    current_time = next_tortoise_time;
    int time_change =(4 - (3 * (drink_level / MAX_DRINK).toDouble())).toInt();
    next_tortoise_time = current_time + time_change;
    update_current_place = false;
    int dx = directionTable[direction][0];
    int dy = directionTable[direction][1];

    // Sensing
    String ahead = worldmap[ypos + dy][xpos + dx];
    String here = worldmap[ypos][xpos];
    bool free_ahead = !(ahead == 'stone' || ahead == 'wall');
    bool lettuce_ahead = ahead == 'lettuce';
    bool lettuce_here = here == 'lettuce';
    bool water_ahead = ahead == 'pond';
    bool water_here = here == 'pond';


    var timedFunc = TimeoutFunction(tortoise_brain.think, 1000);
    try {
      var startTime = DateTime.now().millisecondsSinceEpoch;
      action = timedFunc(sensor);
      var endTime = DateTime.now().millisecondsSinceEpoch;
      current_time += (endTime - startTime) / 1000;
    } on TimeoutFunctionException {
      print("Timed out on a single move!");
      action = 'wait';
    }
    pain = false;

    // Perform action
    if (action == 'left') {
      direction = (direction - 1) % 4;
      drink_level = max(drink_level - 1, 0);
    } else if (action == 'right') {
      direction = (direction + 1) % 4;
      drink_level = max(drink_level - 1, 0);
    } else if (action == 'forward') {
      if (free_ahead) {
        xpos += dx;
        ypos += dy;
      } else {
        health -= 1;
        pain = true;
      }
      drink_level = max(drink_level - 2, 0);
    } else if (action == 'eat' && lettuce_here) {
      drink_level = max(drink_level - 1, 0);
      eaten += 1;
      worldmap[ypos][xpos] = 'ground';
      update_current_place = true;
    } else if (action == 'drink' && water_here) {
      drink_level = MAX_DRINK;
    } else if (action == 'wait') {
      drink_level = max(drink_level - 1, 0);
    }

    // Update score
    if (eaten == lettuce_count) {
      print("You win!");
      action = "stop";
      win = true;
    } else if (drink_level <= 0 || health <= 0) {
      if (drink_level <= 0) {
        print("You died of thirst!");
        win = false;
      } else {
        print("You died of ill health!");
        win = false;
      }
      action = "stop";
      pain = true;
    }
    score = eaten * 10 - (current_time ~/ 10);
  }*/

  void printWorldMap() {
    for (int y = 0; y < grid_size; y++) {
      for (int x = 0; x < grid_size; x++) {
        print('${worldmap[y][x]} ');
      }
      print('\n');
    }
  }

  void createWorldMap(int grid_size) {
    worldmap = List.generate(
        grid_size,
        (y) => List.generate(grid_size,
            (x) => ((y == 0 || y == grid_size - 1 || x == 0 || x == grid_size - 1) ? 'wall' : 'ground')));

    worldmap[1][1] = 'pond';

    // First put out the stones randomly
    for (var i = 0; i < (pow((grid_size - 2), 2) / STONE_PROBABILITY).toInt(); i++) {
      var ok = false;
      while (!ok) {
        var x = Random().nextInt(grid_size - 1) + 1;
        var y = Random().nextInt(grid_size - 1) + 1;

        if (worldmap[y][x] == 'ground') {
          var countStones = 0;
          var countWalls = 0;
          // Check that the stone will not be adjacent to two other stones,
          // or one other stone and a wall.
          // This is to prevent the appearance of inaccessible areas.
          for (var dx in [-1, 0, 1]) {
            for (var dy in [-1, 0, 1]) {
              if (worldmap[y + dy][x + dx] == 'stone') {
                countStones += 1;
              }
              if (worldmap[y + dy][x + dx] == 'wall') {
                countWalls += 1;
              }
            }
          }
          if (countStones == 0 || (countStones <= 1 && countWalls == 0)) {
            worldmap[y][x] = 'stone';
            ok = true;
          }
        }
      }
    }

    // Then put out the lettuces randomly
    for (var i = 0; i < (pow((grid_size - 2), 2) / LETTUCE_PROBABILITY).toInt(); i++) {
      var ok = false;
      while (!ok) {
        var x = Random().nextInt(grid_size - 1) + 1;
        var y = Random().nextInt(grid_size - 1) + 1;

        if (worldmap[y][x] == 'ground') {
          worldmap[y][x] = 'lettuce';
          lettuceCount += 1;
          ok = true;
        }
      }
    }
    // Finally put out the water ponds randomly
    for (var i = 0; i < (pow((grid_size - 2), 2) / WATER_PROBABILITY).toInt(); i++) {
      var ok = false;
      while (!ok) {
        var x = Random().nextInt(grid_size - 1) + 1;
        var y = Random().nextInt(grid_size - 1) + 1;

        if (worldmap[y][x] == 'ground') {
          worldmap[y][x] = 'pond';
          ok = true;
        }
      }
    }
  }
}
