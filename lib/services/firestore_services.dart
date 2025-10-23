// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:playground_2502/models/pixel_art.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final logger = Logger();

  // --- Create or Update User Profile ---
  Future<void> createUserProfile({
    required String uid,
    String? email,
    String? displayName, // From FirebaseAuth
  }) async {
    final DocumentReference userRef = _db.collection('users').doc(uid);
    final DocumentSnapshot doc = await userRef.get();

    if (!doc.exists) {
      // User profile does not exist, create it
      await userRef.set({
        'name': displayName ?? 'New User', // Use display name if available, otherwise a default
        'email': email,
        'preferences': [], // Initialize with an empty list or default preferences
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
      print('Firestore: User profile created for UID: $uid');
    } else {
      // User profile exists, update last login and potentially name/email if they changed
      await userRef.update({
        'name': displayName ?? doc.get('name'), // Update name if changed, otherwise keep existing
        'email': email ?? doc.get('email'), // Update email if changed
        'lastLogin': FieldValue.serverTimestamp(),
      });
      print('Firestore: User profile updated for UID: $uid');
    }
  }

  // --- Create Pixel Art ---
  Future<String?> createPixelArt(PixelArt pixelArt) async {
    try {
      final DocumentReference docRef = await _db.collection('pixelarts').add({
        'authorId': pixelArt.authorId,
        'title': pixelArt.title,
        'description': pixelArt.description,
        'size': pixelArt.size,
        'palette': pixelArt.palette,
        'grid': pixelArt.gridData,
        'createdAt': FieldValue.serverTimestamp(),
        'lastModifiedAt': FieldValue.serverTimestamp(),
      });
      logger.d('Firestore: Pixel Art created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      logger.e('Firestore Error creating pixel art: $e');
      return null;
    }
  }

  // --- Track Pixel Art View ---
  Future<void> trackPixelArtView({
    required String pixelArtId,
    String? viewerId, // Can be null for unauthenticated views
  }) async {
    try {
      await _db.collection('pixelArtViews').add({
        'pixelArtId': pixelArtId,
        'viewerId': viewerId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      logger.d('Firestore: View tracked for pixel art $pixelArtId by $viewerId');
    } catch (e) {
      logger.e('Firestore Error tracking view: $e');
    }
  }

  // --- Fetch User Profile (Optional, but good for displaying user data) ---
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      logger.e('Firestore Error fetching user profile: $e');
      return null;
    }
  }
}
