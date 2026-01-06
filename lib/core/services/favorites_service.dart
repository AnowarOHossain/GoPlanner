// This service saves and loads user favorites to Firebase Firestore cloud database
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Manages cloud storage of user favorites (hotels, restaurants, attractions)
class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Cloud database
  final FirebaseAuth _auth = FirebaseAuth.instance; // For getting current user

  // Get current user's ID (null if not logged in)
  String? get _userId => _auth.currentUser?.uid;

  // Get reference to user's favorites document in Firestore
  // Path: users/{userId}/data/favorites
  DocumentReference<Map<String, dynamic>>? get _userFavoritesDoc {
    final userId = _userId;
    if (userId == null) return null;
    return _firestore.collection('users').doc(userId).collection('data').doc('favorites');
  }

  // Save all favorites to Firestore
  Future<void> saveFavorites({
    required List<String> hotels,
    required List<String> restaurants,
    required List<String> attractions,
  }) async {
    final doc = _userFavoritesDoc;
    if (doc == null) {
      print('Cannot save favorites: User not logged in');
      return;
    }

    try {
      await doc.set({
        'hotels': hotels,
        'restaurants': restaurants,
        'attractions': attractions,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('Favorites saved to Firestore successfully');
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  // Load favorites from Firestore
  Future<Map<String, List<String>>> loadFavorites() async {
    final doc = _userFavoritesDoc;
    if (doc == null) {
      print('Cannot load favorites: User not logged in');
      return {'hotels': [], 'restaurants': [], 'attractions': []};
    }

    try {
      final snapshot = await doc.get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        print('Favorites loaded from Firestore successfully');
        return {
          'hotels': List<String>.from(data['hotels'] ?? []),
          'restaurants': List<String>.from(data['restaurants'] ?? []),
          'attractions': List<String>.from(data['attractions'] ?? []),
        };
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
    return {'hotels': [], 'restaurants': [], 'attractions': []};
  }

  // Add a single item to favorites
  Future<void> addFavorite(String id, String type) async {
    final doc = _userFavoritesDoc;
    if (doc == null) return;

    try {
      await doc.set({
        type: FieldValue.arrayUnion([id]),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('Added $id to $type favorites successfully');
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  // Remove a single item from favorites
  Future<void> removeFavorite(String id, String type) async {
    final doc = _userFavoritesDoc;
    if (doc == null) return;

    try {
      await doc.update({
        type: FieldValue.arrayRemove([id]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Removed $id from $type favorites successfully');
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  // Stream of favorites for real-time updates
  Stream<Map<String, List<String>>> favoritesStream() {
    final doc = _userFavoritesDoc;
    if (doc == null) {
      return Stream.value({'hotels': [], 'restaurants': [], 'attractions': []});
    }

    return doc.snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        return {
          'hotels': List<String>.from(data['hotels'] ?? []),
          'restaurants': List<String>.from(data['restaurants'] ?? []),
          'attractions': List<String>.from(data['attractions'] ?? []),
        };
      }
      return {'hotels': [], 'restaurants': [], 'attractions': []};
    });
  }
}
