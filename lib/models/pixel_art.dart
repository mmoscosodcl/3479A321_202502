// filepath: /Users/manuel/Documents/flutter_projects/playground_2502/lib/models/pixel_art.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class PixelArt {
  final String id;
  final String authorId;
  final String title;
  final String description;
  final Map<String, dynamic> size;
  final List<String> palette;
  final String gridData;
  final DateTime createdAt;
  final DateTime lastModifiedAt;

  PixelArt({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.size,
    required this.palette,
    required this.gridData,
    required this.createdAt,
    required this.lastModifiedAt,
  });

  // Factory constructor to create a PixelArt instance from Firestore data
  factory PixelArt.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PixelArt(
      id: doc.id,
      authorId: data['authorId'] as String,
      title: data['title'] as String,
      description: data['description'] as String? ?? '',
      size: data['size'] as Map<String, dynamic>,
      palette: List<String>.from(data['palette'] as List),
      gridData: data['grid'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastModifiedAt: (data['lastModifiedAt'] as Timestamp).toDate(),
    );
  }

  // Convert PixelArt instance to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'title': title,
      'description': description,
      'size': size,
      'palette': palette,
      'grid': gridData,
      'createdAt': createdAt,
      'lastModifiedAt': lastModifiedAt,
    };
  }
}