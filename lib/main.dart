import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    var logger = Logger();
    logger.d("Logger is working!");
    
    return MaterialApp(
      title: '3479A321_202502',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
        // ···
        titleLarge: GoogleFonts.oswald(
          fontSize: 30,
          fontStyle: FontStyle.italic,
        ),
        bodyMedium: GoogleFonts.merriweather(),
        displaySmall: GoogleFonts.pacifico(),
      )
      ),
      home: const MyHomePage(title: '3479A321_202502'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Pixel Art sobre una grilla personalizable:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Image.asset(
                    'assets/Pixel-Art-Hot-Pepper-2-1.webp',
                    width: 200, // Optional: set the width of the image
                    height: 200, // Optional: set the height of the image
                    fit: BoxFit.cover, // Optional: how the image should be resized to fit the box
                  ),
                  Image.asset(
                    'assets/Pixel-Art-Pizza-2.webp',
                    width: 200, // Optional: set the width of the image
                    height: 200, // Optional: set the height of the image
                    fit: BoxFit.cover, // Optional: how the image should be resized to fit the box
                  ),
                  Image.asset(
                    'assets/Pixel-Art-Watermelon-3.webp',
                    width: 200, // Optional: set the width of the image
                    height: 200, // Optional: set the height of the image
                    fit: BoxFit.cover, // Optional: how the image should be resized to fit the box
                  ),
                ],
              ),
            )
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
