import 'package:flutter/material.dart';

class ListCreationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pixel Art List'),
      ),
      body: Center(
        child: Text(
          'Lista de pixel art disponibles',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
