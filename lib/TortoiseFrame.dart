import 'package:flutter/material.dart';
import 'tortoiseWorld.dart';

class TortoiseFrame extends StatefulWidget {
  final TortoiseWorld tortoiseWorld;

  TortoiseFrame({required this.tortoiseWorld});

  @override
  _TortoiseFrameState createState() => _TortoiseFrameState();
}

class _TortoiseFrameState extends State<TortoiseFrame> {
  late List<List<String>> worldMap;
  Map<String, Image> images = {};

  @override
  void initState() {
    super.initState();
    worldMap = widget.tortoiseWorld.worldmap;
    for (String img in ['wall','lettuce','pond','ground','stone','tortoise-n','tortoise-s','tortoise-w','tortoise-e','tortoise-dead']) {
      images[img] = Image.asset('assets/images/$img.gif');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tortoise World'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildGridView(),
            SizedBox(height: 16.0),
            Text('Additional Info'),
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: worldMap.length,
      ),
      itemBuilder: (BuildContext context, int index) {
        int x = index % worldMap.length;
        int y = index ~/ worldMap.length;

        return buildOverlayImage(x, y);
      },
      itemCount: worldMap.length * worldMap.length,
    );
  }

  Widget buildOverlayImage(int x, int y) {
    String imageName = worldMap[y][x];
    String img = 'assets/images/$imageName.gif';
    print(img);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: FittedBox(
        fit: BoxFit.cover,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/ground.gif', // Image de fond (terre)
            ),
            Image.asset(
              img,
            ), // Use AssetImage to provide ImageProvider
          ],
        ),
      ),
    );
  }
}