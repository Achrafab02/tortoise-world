import 'package:flutter/material.dart';
import 'package:tortoise_world/game/tortoise_world.dart';
import 'package:tortoise_world/game_presenter.dart';

import 'board_cell.dart';

class BoardView extends StatefulWidget {
  final GamePresenter gamePresenter;

  const BoardView(this.gamePresenter, {super.key});

  @override
  BoardViewState createState() => BoardViewState();
}

class BoardViewState extends State<BoardView> {
  @override
  void initState() {
    widget.gamePresenter.setBoardView(this);
    widget.gamePresenter.initializeWorldMap();
    super.initState();
  }

  @override
  void dispose() {
    widget.gamePresenter.dispose();
    super.dispose();
  }

  String _getImageFromCellType(CellType tileType) {
    switch (tileType) {
      case CellType.pond:
        return 'pond';
      case CellType.lettuce:
        return 'lettuce';
      case CellType.wall:
        return 'wall';
      case CellType.stone:
        return 'stone';
      case CellType.ground:
        return 'ground';
    }
  }

  void showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          contentTextStyle: const TextStyle(color: Colors.black),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void update() async => setState(() {});

  @override
  Widget build(BuildContext context) {
    final tortoiseWorld = widget.gamePresenter.tortoiseWorld;
    return SingleChildScrollView(
      child: Container(
        width: 500,
        height: 600,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: tortoiseWorld.gridSize,
              ),
              itemBuilder: (BuildContext context, int index) {
                int x = index % tortoiseWorld.gridSize;
                int y = index ~/ tortoiseWorld.gridSize;
                bool isTortoisePosition = tortoiseWorld.xPos == x && tortoiseWorld.yPos == y;
                return BoardCell(
                  imageName: _getImageFromCellType(tortoiseWorld.getCellContent(x, y)),
                  tortoiseImage: tortoiseWorld.tortoiseImage,
                  isTortoisePosition: isTortoisePosition,
                );
              },
              itemCount: tortoiseWorld.gridSize * tortoiseWorld.gridSize,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text.rich(TextSpan(children: [
                  const TextSpan(text: "Salades : ", style: TextStyle(fontSize: 16)),
                  TextSpan(text: "${tortoiseWorld.eaten} ", style: const TextStyle(fontSize: 20)),
                ])),
                Text.rich(TextSpan(children: [
                  const TextSpan(text: "Temps : ", style: TextStyle(fontSize: 16)),
                  TextSpan(text: "${tortoiseWorld.moveCount} ", style: const TextStyle(fontSize: 20)),
                ])),
                Text.rich(TextSpan(children: [
                  const TextSpan(text: "Score : ", style: TextStyle(fontSize: 16)),
                  TextSpan(text: "${tortoiseWorld.score} ", style: const TextStyle(fontSize: 20)),
                ])),
                Text.rich(TextSpan(children: [
                  const TextSpan(text: "Niveau boisson : ", style: TextStyle(fontSize: 16)),
                  TextSpan(text: "${tortoiseWorld.drinkLevel} ", style: const TextStyle(fontSize: 20)),
                ])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
