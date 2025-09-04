import 'package:flutter/material.dart';

class ListArtScreen extends StatelessWidget {

  final List<String> artTitles = [
    'Pixel Art 1',
    'Pixel Art 2',
    'Pixel Art 3',
    'Pixel Art 4',
    'Pixel Art 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pixel Art List'),
      ),
      body: ListView.builder(
        itemCount: artTitles.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.image),
            title: Text(artTitles[index]),
            onTap: () {
              // Handle tap event, e.g., navigate to detail screen
            },
          );
        },
      ),
    );
  }
}