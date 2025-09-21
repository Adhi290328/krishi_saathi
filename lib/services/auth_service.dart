// services/auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();
      
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      throw Exception('Failed to get user data: $e');
    }
  }

  // Create user data in Firestore
  Future<void> createUserData(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(user.toMap());
      
      debugPrint('User data created successfully for uid: ${user.uid}');
    } catch (e) {
      debugPrint('Error creating user data: $e');
      throw Exception('Failed to create user data: $e');
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .update(user.toMap());
      
      debugPrint('User data updated successfully for uid: ${user.uid}');
    } catch (e) {
      debugPrint('Error updating user data: $e');
      throw Exception('Failed to update user data: $e');
    }
  }

  // Delete user data from Firestore
  Future<void> deleteUserData(String uid) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .delete();
      
      debugPrint('User data deleted successfully for uid: $uid');
    } catch (e) {
      debugPrint('Error deleting user data: $e');
      throw Exception('Failed to delete user data: $e');
    }
  }

  // Check if user exists in Firestore
  Future<bool> userExists(String uid) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();
      
      return doc.exists;
    } catch (e) {
      debugPrint('Error checking if user exists: $e');
      return false;
    }
  }

  // Update specific user field
  Future<void> updateUserField(String uid, String field, dynamic value) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .update({
        field: value,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      debugPrint('User field $field updated successfully for uid: $uid');
    } catch (e) {
      debugPrint('Error updating user field: $e');
      throw Exception('Failed to update user field: $e');
    }
  }

  // Get multiple users (for admin purposes or user search)
  Future<List<UserModel>> getUsers({
    int limit = 20,
    String? lastUserId,
  }) async {
    try {
      Query query = _firestore
          .collection(_usersCollection)
          .orderBy('createdAt', descending: true)
          .limit(limit);
      
      if (lastUserId != null) {
        final lastDoc = await _firestore
            .collection(_usersCollection)
            .doc(lastUserId)
            .get();
        
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }
      
      final querySnapshot = await query.get();
      
      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting users: $e');
      throw Exception('Failed to get users: $e');
    }
  }

  // Search users by display name or email
  Future<List<UserModel>> searchUsers(String searchTerm) async {
    try {
      // Note: Firestore doesn't support full-text search natively
      // This is a basic implementation - consider using Algolia or similar for better search
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('displayName', isGreaterThanOrEqualTo: searchTerm)
          .where('displayName', isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .limit(20)
          .get();
      
      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error searching users: $e');
      throw Exception('Failed to search users: $e');
    }
  }

  // Listen to user data changes (real-time)
  Stream<UserModel?> getUserDataStream(String uid) {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    });
  }

  // Batch operations
  Future<void> batchUpdateUsers(List<UserModel> users) async {
    try {
      final batch = _firestore.batch();
      
      for (final user in users) {
        final docRef = _firestore.collection(_usersCollection).doc(user.uid);
        batch.update(docRef, user.toMap());
      }
      
      await batch.commit();
      debugPrint('Batch update completed for ${users.length} users');
    } catch (e) {
      debugPrint('Error in batch update: $e');
      throw Exception('Failed to batch update users: $e');
    }
  }

  // Get user statistics
  Future<Map<String, int>> getUserStats() async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .get();
      
      int totalUsers = querySnapshot.docs.length;
      int verifiedUsers = querySnapshot.docs
          .where((doc) => (doc.data())['isEmailVerified'] == true)
          .length;
      
      return {
        'totalUsers': totalUsers,
        'verifiedUsers': verifiedUsers,
        'unverifiedUsers': totalUsers - verifiedUsers,
      };
    } catch (e) {
      debugPrint('Error getting user stats: $e');
      throw Exception('Failed to get user stats: $e');
    }
  }
}