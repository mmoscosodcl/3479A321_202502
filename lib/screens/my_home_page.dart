import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:playground_2502/screens/about.dart';
import 'package:playground_2502/screens/list_art.dart';
import 'package:playground_2502/screens/list_creations.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _defaultValue = 12;
  Color _color = Colors.cyanAccent;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _restoreCounter() {
    setState(() {
      _counter = _defaultValue;
    });
  }

  void _setColor() {
    setState(() {
      if (_color != Colors.green) {
        _color = Colors.green; // Change to green if not already
      } else {
        _color = Colors.cyanAccent; // Reset to default color
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    var logger = Logger();
    logger.d("Logger is working in build method of _MyHomePageState!");
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
    PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'about') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutScreen()), // Navigate to AboutScreen
          );
        }
        if (value == 'list_creation') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListCreationScreen()), // Navigate to ListCreationScreen
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'about',
            child: Text('About'),
          ),
          const PopupMenuItem<String>(
            value: 'list_creation',
            child: Text('Lista Creaciones'),
          ),
        ];
      },
    )
  ],
      ),
      body: Center(
       child: Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),

         child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:[ Image.asset(
                    'assets/Pixel-Art-Hot-Pepper-2-1.webp',
                    width: 400, // Optional: set the width of the image
                    fit: BoxFit.cover, // Optional: how the image should be resized to fit the box
                  ),
                  Image.asset(
                    'assets/Pixel-Art-Pizza-2.webp',
                    width: 400, // Optional: set the width of the image
                    fit: BoxFit.cover, // Optional: how the image should be resized to fit the box
                  ),
                  Image.asset(
                    'assets/Pixel-Art-Watermelon-3.webp',
                    width: 400, // Optional: set the width of the image
                    fit: BoxFit.cover, // Optional: how the image should be resized to fit the box
                  ),
                  ]
                ),
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Crear'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListArtScreen()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Compartir'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            ],
          ),
       ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        backgroundColor: _color,
        tooltip: 'Increment',
        heroTag: 'screen1_fab',
        child: const Icon(Icons.stop_circle_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: _decrementCounter,
          child: const Icon(Icons.remove),
        ),
        ElevatedButton(
          onPressed: _restoreCounter,
          child: const Icon(Icons.restore),
        ),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Icon(Icons.add),
        ),
        ElevatedButton(
          onPressed: _setColor,
          child: const Icon(Icons.star),
        ),
      ],
    );
  }
}
