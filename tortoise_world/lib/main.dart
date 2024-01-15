import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tortoise World'),
        ),
        body: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Container(
                      width: 200.0,
                      height: 200.0,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5.0),
              Expanded(
                child: Container(
                  color: Colors.blueGrey,
                  child: Center(
                    child: Container(
                      width: 150.0,
                      height: 150.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print("Start Button Clicked");
                            },
                            child: Text('Start'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print("Clear Button Clicked");
                            },
                            child: Text('Clear'),
                          ),
                          Container(
                            width: 150.0,
                            height: 50.0,
                            color: Colors.white,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Entrez votre code ici',
                                contentPadding: EdgeInsets.all(8.0),
                              ),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.0),
        Expanded(
          child: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Instructions:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  'Ajoutez vos instructions ici.',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
