import 'package:flutter/material.dart';

class SnakePage extends StatelessWidget {
  const SnakePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // TODO: Implement your back button logic here
            Navigator.pop(context);
          },
        ),
        title: Text('Snake Game'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              // TODO: Implement your menu actions here
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Pause',
                child: Text('Pause'),
              ),
              const PopupMenuItem<String>(
                value: 'Replay',
                child: Text('Replay'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Container(
              color: Colors.green,
              // TODO: Add your game grid here
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement left direction logic
                  },
                  child: Icon(Icons.arrow_left),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement up direction logic
                      },
                      child: Icon(Icons.arrow_upward),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement down direction logic
                      },
                      child: Icon(Icons.arrow_downward),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement right direction logic
                  },
                  child: Icon(Icons.arrow_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
