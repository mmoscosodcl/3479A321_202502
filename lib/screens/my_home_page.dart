import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:playground_2502/screens/about.dart';
import 'package:playground_2502/screens/configuration.dart';
import 'package:playground_2502/screens/list_art.dart';
import 'package:playground_2502/screens/list_creations.dart';
import 'package:playground_2502/screens/pixel_art.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _lastImage; // To store the last created image file

  @override
  void initState() {
    super.initState();
    _loadLastImage(); // Load the last image when the screen initializes
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadLastImage(); // Reload the last image when dependencies change
  }

  Future<void> _loadLastImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync(); // List all files in the directory

    // Filter PNG files and sort them by creation time (most recent first)
    final pngFiles = files
        .where((file) => file.path.endsWith('.png'))
        .toList()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

    if (pngFiles.isNotEmpty) {
      setState(() {
        _lastImage = File(pngFiles.first.path); // Get the most recent image
      });
    }
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
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              }
              if (value == 'list_creation') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListCreationScreen()),
                );
              }
              if (value == 'list_art') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListArtScreen()),
                );
              }
              if (value == 'configuration') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfigurationScreen()),
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
                const PopupMenuItem<String>(
                  value: 'list_art',
                  child: Text('Lista Artes'),
                ),
                const PopupMenuItem<String>(
                  value: 'configuration',
                  child: Text('Configuración'),
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
              if (_lastImage != null)
                Image.file(
                  _lastImage!,
                  width: 400,
                  fit: BoxFit.cover,
                )
              else
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No image created yet!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      // Add sharing functionality here
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PixelArtScreen()),
          ).then(
            (value) => _loadLastImage(),
          );
        },
        backgroundColor: Colors.cyanAccent,
        tooltip: 'Create Pixel Art',
        heroTag: 'screen1_fab',
        child: const Icon(Icons.new_label),
      ),
    );
  }
}
