import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ListCreationScreen extends StatefulWidget {
  @override
  _ListCreationScreenState createState() => _ListCreationScreenState();
}

class _ListCreationScreenState extends State<ListCreationScreen> {
  List<String> _creations = []; // List to store file paths

  @override
  void initState() {
    super.initState();
    _loadCreations(); // Load creations when the screen is initialized
  }

  Future<void> _loadCreations() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync(); // List all files in the directory

    setState(() {
      _creations = files
          .where((file) => file.path.endsWith('.png')) // Filter PNG files
          .map((file) => file.path)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pixel Art Gallery'),
      ),
      body: _creations.isEmpty
          ? Center(
              child: Text(
                'No creations yet!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _creations.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    File(_creations[index]), // Use File to load the image from the path
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }
}
