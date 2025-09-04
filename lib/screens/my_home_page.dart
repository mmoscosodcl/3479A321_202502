import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:playground_2502/main.dart';

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

  Color _newColor = Colors.red;

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
      ),
      body: Center(
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Pixel Art sobre una grilla personalizable:'),
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
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        backgroundColor: _color,
        tooltip: 'Increment',
        child: const Icon(Icons.stop_circle_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      persistentFooterButtons: [
        FloatingActionButton(
          onPressed: _decrementCounter,
          tooltip: 'Decrement',
          child: const Icon(Icons.remove),
        ),
        FloatingActionButton(
          onPressed: _restoreCounter,
          tooltip: 'Restore',
          child: const Icon(Icons.restore),
        ),
        FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: _setColor,
          backgroundColor: _color,
          tooltip: 'Custom Action',
          child: const Icon(Icons.star),
        ),
      ],
    );
  }
}
