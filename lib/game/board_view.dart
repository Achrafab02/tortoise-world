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

class BoardViewState extends State<BoardView> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.gamePresenter.setBoard(ticker: createTicker((elapsed) => _update(elapsed)));
    widget.gamePresenter.initializeWorldMap();
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

  void _update(Duration elapsed) {
    setState(() {
      widget.gamePresenter.update(elapsed, this);
    });
  }

  @override
  Widget build(BuildContext context) {
    var tortoiseWorld = widget.gamePresenter.tortoiseWorld;
    return SingleChildScrollView(
      child: Container(
        width: 500,
        height: 600,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: tortoiseWorld.columns,
              ),
              itemBuilder: (BuildContext context, int index) {
                int x = index % tortoiseWorld.columns;
                int y = index ~/ tortoiseWorld.columns;
                bool isTortoisePosition = tortoiseWorld.xpos == x && tortoiseWorld.ypos == y;
                return BoardCell(
                  imageName: _getImageFromCellType(tortoiseWorld.getCellContent(x, y)),
                  tortoiseImage: tortoiseWorld.tortoiseImage,
                  isTortoisePosition: isTortoisePosition,
                );
              },
              itemCount: tortoiseWorld.rows * tortoiseWorld.columns,
            ),
            const SizedBox(height: 20),
            Text("Salades: ${tortoiseWorld.eaten} Temps: ${tortoiseWorld.moveCount} Score: ${tortoiseWorld.score} Niveau d'eau: ${tortoiseWorld.drinkLevel}"),
          ],
        ),
      ),
    );
  }
}
