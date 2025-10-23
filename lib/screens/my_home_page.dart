import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:playground_2502/screens/about.dart';
import 'package:playground_2502/screens/configuration.dart';
import 'package:playground_2502/screens/list_art.dart';
import 'package:playground_2502/screens/list_creations.dart';
import 'package:playground_2502/screens/pixel_art.dart';
import 'package:playground_2502/screens/sing_in_screen.dart';
import 'package:playground_2502/services/firestore_services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _lastImage; // To store the last created image file
  final FirestoreService _firestoreService = FirestoreService(); // Instance of our service
  late final StreamSubscription<User?> _authStateChangesSubscription; // To manage the stream subscription

  @override
  void initState() {
    super.initState();
    _loadLastImage(); // Load the last image when the screen initializes
    // Listen for auth state changes to automatically log in or update profile
    _authStateChangesSubscription = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null && mounted) {
        // User is signed in (or a session was restored)
        // Ensure their Firestore profile is created/updated
        await _firestoreService.createUserProfile(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
        );

        // Now navigate to the home screen
        // pushReplacement ensures the user can't go back to WelcomeScreen with the back button
        /*if (mounted) { // Check if widget is still mounted before navigating
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const List()),
          );
        }*/
      }
    });
  }

  @override
  void dispose() {
    // It's important to cancel the stream subscription when the widget is disposed
    _authStateChangesSubscription.cancel(); // Ensure the subscription is managed correctly
    super.dispose();
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
              if (value == 'login') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInSignUpScreen()),
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
                const PopupMenuItem<String>(
                  value: 'login',
                  child: Text('Iniciar sesión'),
                )
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
              //Show FirebaseAuth.instance.currentUser?.uid
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'User ID: ${FirebaseAuth.instance.currentUser?.uid ?? "Not signed in"}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),

              TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: const Text('Log Out'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {

                },
                child: const Text('Compartir'),
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
