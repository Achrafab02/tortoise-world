
import 'package:flutter/material.dart';
import 'package:tortoise_world/Presenter/LLGrammarPresenter/GrammarPresenter.dart';
import '../Model/LLGrammarModel/GrammarModel.dart';
import '../Model/LLGrammarModel/Lexer.dart';
import '../Model/LLGrammarModel/Parser.dart';
import '../Model/LLGrammarModel/Token.dart';

import 'dart:math';


import 'package:flutter/scheduler.dart';
import 'package:tortoise_world/Model/model.dart';
import 'package:tortoise_world/View/utils.dart';

import 'StartPage.dart';
import 'case.dart';


void main() {
  runApp(SplitWindowApp());
}

class SplitWindowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        body: SplitScreen(),
      ),
    );
  }
}

class SplitScreen extends StatefulWidget {
  @override
  _SplitScreenState createState() => _SplitScreenState();
}
GrammarPresenter presenter = GrammarPresenter();
class _SplitScreenState extends State<SplitScreen> {
  final GlobalKey<_GameScreenState> _gameScreenKey = GlobalKey<_GameScreenState>();

  String code = '';
  bool isCodeExecuted = false;

  // Fonction pour arrêter l'exécution du code
  void _stopCodeExecution() {
    setState(() {
      isCodeExecuted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tortoise World',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => StartPage()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Instructions du jeu'),
                    content: Text('Bienvenue dans le monde de la tortue! \n'
                        '- Pour faire avancer la tortue, il faut que la case devant elle soit libre. on verifie cette condition avec le code suivant: \n'
                        'if capteur.libre_devant : return AVANCE\n'
                        '- Pour faire manger la tortue. on execute le code suivant: \n'
                        'if capteur.laitue_ici : return MANGE\n'
                        '- Pour faire boire la tortue, on execute le code suivant: \n'
                        'if capteur.eau_ici : return BOIT\n'
                        '- Pour faire tourner la tortue a gauche, on execute le code suivant: \n'
                        'return GAUCHE\n'
                        '- Pour faire tourner la tortue a droite, on execute le code suivant: \n'
                        'return DROITE\n'
                        '- Si vous hesitez, vous pouvez utiliser l\'aleatoire pour faire bouger la tortue, pour cela, vous pouvez utiliser le code suivant: \n'
                        'return random([GAUCHE, DROITE, AVANCE, MANGE, BOIT])\n'
                        'Bonne chance!',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Roboto'
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Fermer'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF7697A0), Color(0xFFDDDDDA)],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              // Partie gauche de la fenêtre
              child: Container(
                color: Colors.transparent, // Remplacez la couleur solide par transparent
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Éditeur de Code',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          code = value;
                        });
                      },
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Courier New',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Écrivez votre code ici',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10.0),

                      ),
                      maxLines: 10,
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                code = code.replaceAll('random', 'random.choise');
                                var lexer = Lexer(code);
                                var model = GrammarModel(lexer);
                                var token = <Token>[];
                                while (true) {
                                  token.add(model.lexer.getNextToken());
                                  if (token.last.type == TokenType.EOF) {
                                    break;
                                  }
                                }
                                var parser = Parser(token);
                                bool hasError = false;
                                try {
                                  parser.parse();
                                  presenter.setParser(parser);
                                } catch (e) {
                                  showErrorDialog(context, e.toString().replaceFirst('Exception: ', ''));
                                  hasError = true;
                                }
                                if (!hasError) {
                                  presenter.tortoise = Tortoise(worldMap: presenter.tortoise.worldMap);
                                  // Exécuter le code et mettre à jour la grille
                                  setState(() {
                                    isCodeExecuted = true;
                                  });
                                }
                                parser.parse();
                                presenter.setParser(parser);
                              },
                              child: Text('Exécuter'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                foregroundColor: Colors.white, backgroundColor: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: _stopCodeExecution, // Appeler la fonction d'arrêt
                              child: Text('Stop'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                foregroundColor: Colors.white, backgroundColor: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              // Partie droite de la fenêtre
              child: Container(
                color: Colors.transparent, // Remplacez la couleur solide par transparent
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: isCodeExecuted ? GameScreen() : Text('Aucun code à exécuter, ou code arrêté'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Correction de code'),
        content: Text('Vous devez corriger votre code: $message'),
        actions: <Widget>[
          TextButton(
            child: Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}




class GameScreen extends StatefulWidget {
  GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {

  final int rows = 12;
  final int columns = 12;
  List<List<String>> worldMap = [];
  String tortoiseImage = "./assets/images/tortoise-e.gif";
  Tortoise tortoise = presenter.tortoise;
  int eaten = 0;
  int score = 0;
  int time = 0;
  int drinkLevel = MAX_DRINK;
  late Ticker _ticker;
  double cumulativeTime=0;



  @override
  void initState() {
    super.initState();
    initializeWorldMap();
    _ticker = createTicker((elapsed) => _update(elapsed));

    _ticker.start();

  }

  void initializeWorldMap() {
    int countLettuce = 0;
    for (int i = 0; i < rows; i++) {
      List<String> rowTypes = [];
      for (int j = 0; j < columns; j++) {
        rowTypes.add("ground");
      }
      worldMap.add(rowTypes);
    }

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        String type = selectTileType(j, i);
        worldMap[i][j] = type;
        if (type == 'lettuce') {
          countLettuce++;
        }
      }
    }

    tortoise.worldMap = worldMap;
    tortoise.updateLettuceCount(countLettuce);
  }
  String selectTileType(int x, int y) {
    if (x == 1 && y == 1) {
      return 'pond';
    } else if (x == 0 || x == columns - 1 || y == 0 || y == rows - 1) {
      return 'wall';
    } else {
      double stoneProbability = 0.1;
      double lettuceProbability = 0.2;
      double pondProbability = 0.1;

      double randomValue = Random().nextDouble();

      String overlayImage = 'ground';

      if (randomValue < stoneProbability) {
        overlayImage = 'stone';
      } else if (randomValue < stoneProbability + lettuceProbability) {
        overlayImage = 'lettuce';
      } else if (randomValue <
          stoneProbability + lettuceProbability + pondProbability) {
        overlayImage = 'pond';
      }

      return overlayImage;
    }
  }

  String getImageFromType(String tileType) {
    switch (tileType) {
      case 'pond':
        return 'assets/images/pond.gif';
      case 'lettuce':
        return 'assets/images/lettuce.gif';
      case 'wall':
        return 'assets/images/wall.gif';
      case 'stone':
        return 'assets/images/stone.gif';
      default:
        return 'assets/images/ground.gif';
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void showresultDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _update(Duration elapsed) {
    setState(() {
      cumulativeTime+=1500;
      if(cumulativeTime>DELAY_IN_MS && tortoise.moveCount<=MAX_TIME && tortoise.action!="stop"){
        cumulativeTime=0;
        String result = tortoise.moveTortoise(presenter.tortoise.think(presenter.tortoiseBrain.parser.resultMap.data));
        if (result == "Vous êtes mort de soif!") {
          _ticker.stop();
          showresultDialog(context, result);
        }
        if (result == "Vous êtes mort de faim!") {
          _ticker.stop();
          showresultDialog(context, result);
        }
        tortoiseImage = "./assets/images/${tortoise.tortoiseImage}.gif";
        eaten = tortoise.eaten;
        score = tortoise.score;
        drinkLevel = tortoise.drinkLevel;
        time = tortoise.moveCount;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Container(
        width: 500,
        height: 600,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
              ),
              itemBuilder: (BuildContext context, int index) {
                int x = index % columns;
                int y = index ~/ columns;
                bool isTortoisePositon =
                    tortoise.xpos == x && tortoise.ypos == y;
                return CaseImage(
                  imageName: getImageFromType(worldMap[y][x]),
                  tortoiseImage: tortoiseImage,
                  isTortoisePosition: isTortoisePositon,
                );
              },
              itemCount: rows * columns,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Eaten: $eaten "),
                Text("Time: $time "),
                Text("Score: $score "),
                Text("Drink Level: $drinkLevel "),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

