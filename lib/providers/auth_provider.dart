// providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AuthService _authService = AuthService();

  // State variables
  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  // Constructor
  AuthProvider() {
    _initializeAuth();
  }

  // Initialize authentication state
  Future<void> _initializeAuth() async {
    try {
      _setLoading(true);
      
      // Listen to auth state changes
      _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
      
      // Check if user is already signed in
      _user = _firebaseAuth.currentUser;
      
      if (_user != null) {
        await _loadUserData();
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize authentication: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Handle auth state changes
  void _onAuthStateChanged(User? user) async {
    if (user != _user) {
      _user = user;
      
      if (user != null) {
        await _loadUserData();
      } else {
        _userModel = null;
        await _clearUserData();
      }
      
      notifyListeners();
    }
  }

  // Load user data from Firestore or your backend
  Future<void> _loadUserData() async {
    if (_user == null) return;
    
    try {
      _userModel = await _authService.getUserData(_user!.uid);
      
      // If user data doesn't exist, create it
      if (_userModel == null) {
        _userModel = UserModel(
          uid: _user!.uid,
          email: _user!.email ?? '',
          displayName: _user!.displayName ?? '',
          photoURL: _user!.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await _authService.createUserData(_userModel!);
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  // Clear user data from local storage
  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint('Error clearing user data: $e');
    }
  }

  // Email/Password Sign In
  Future<bool> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      _setLoading(true);
      clearError();

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Save remember me preference
        if (rememberMe) {
          await _saveLoginPreferences(email);
        }
        
        return true;
      }
      
      return false;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Email/Password Sign Up
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    String? phoneNumber,
  }) async {
    try {
      _setLoading(true);
      clearError();

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(displayName);
        
        // Send email verification
        await credential.user!.sendEmailVerification();
        
        // Create user data in Firestore
        _userModel = UserModel(
          uid: credential.user!.uid,
          email: email,
          displayName: displayName,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await _authService.createUserData(_userModel!);
        
        return true;
      }
      
      return false;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      clearError();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in
        return false;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      return userCredential.user != null;
    } catch (e) {
      _setError('Google sign-in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      clearError();

      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      _setError('Failed to send reset email: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      
      // Sign out from Firebase
      await _firebaseAuth.signOut();
      
      // Sign out from Google
      await _googleSignIn.signOut();
      
      // Clear local data
      await _clearUserData();
      
      _user = null;
      _userModel = null;
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
  }) async {
    try {
      _setLoading(true);
      clearError();

      if (_user == null) {
        _setError('No user logged in');
        return false;
      }

      // Update Firebase Auth profile
      if (displayName != null || photoURL != null) {
        await _user!.updateProfile(
          displayName: displayName,
          photoURL: photoURL,
        );
      }

      // Update user model
      if (_userModel != null) {
        _userModel = _userModel!.copyWith(
          displayName: displayName ?? _userModel!.displayName,
          photoURL: photoURL ?? _userModel!.photoURL,
          phoneNumber: phoneNumber ?? _userModel!.phoneNumber,
          updatedAt: DateTime.now(),
        );
        
        await _authService.updateUserData(_userModel!);
      }

      // Reload user to get updated data
      await _user!.reload();
      _user = _firebaseAuth.currentUser;
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Change Password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _setLoading(true);
      clearError();

      if (_user == null) {
        _setError('No user logged in');
        return false;
      }

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: _user!.email!,
        password: currentPassword,
      );
      
      await _user!.reauthenticateWithCredential(credential);
      
      // Update password
      await _user!.updatePassword(newPassword);
      
      return true;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      _setError('Failed to change password: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete Account
  Future<bool> deleteAccount(String password) async {
    try {
      _setLoading(true);
      clearError();

      if (_user == null) {
        _setError('No user logged in');
        return false;
      }

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: _user!.email!,
        password: password,
      );
      
      await _user!.reauthenticateWithCredential(credential);
      
      // Delete user data from Firestore
      if (_userModel != null) {
        await _authService.deleteUserData(_userModel!.uid);
      }
      
      // Delete user account
      await _user!.delete();
      
      // Clear local data
      await _clearUserData();
      
      return true;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      _setError('Failed to delete account: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Save login preferences
  Future<void> _saveLoginPreferences(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', email);
      await prefs.setBool('remember_me', true);
    } catch (e) {
      debugPrint('Error saving login preferences: $e');
    }
  }

  // Get saved login preferences
  Future<Map<String, dynamic>> getLoginPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'email': prefs.getString('saved_email') ?? '',
        'remember_me': prefs.getBool('remember_me') ?? false,
      };
    } catch (e) {
      debugPrint('Error getting login preferences: $e');
      return {'email': '', 'remember_me': false};
    }
  }

  // Handle Firebase Auth errors
  void _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        _setError('No user found with this email address.');
        break;
      case 'wrong-password':
        _setError('Incorrect password. Please try again.');
        break;
      case 'invalid-email':
        _setError('Please enter a valid email address.');
        break;
      case 'user-disabled':
        _setError('This account has been disabled.');
        break;
      case 'too-many-requests':
        _setError('Too many failed attempts. Please try again later.');
        break;
      case 'email-already-in-use':
        _setError('An account already exists with this email address.');
        break;
      case 'weak-password':
        _setError('Password is too weak. Please use a stronger password.');
        break;
      case 'network-request-failed':
        _setError('Network error. Please check your internet connection.');
        break;
      case 'invalid-credential':
        _setError('Invalid credentials. Please check your email and password.');
        break;
      default:
        _setError('Authentication failed: ${e.message ?? e.code}');
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  // Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Refresh user data
  Future<void> refreshUserData() async {
    if (_user != null) {
      await _loadUserData();
      notifyListeners();
    }
  }

  // Check if email is verified
  bool get isEmailVerified => _user?.emailVerified ?? false;

  // Send email verification
  Future<bool> sendEmailVerification() async {
    try {
      if (_user != null && !_user!.emailVerified) {
        await _user!.sendEmailVerification();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to send verification email: ${e.toString()}');
      return false;
    }
  }

  // Reload user to check email verification status
  Future<void> reloadUser() async {
    if (_user != null) {
      await _user!.reload();
      _user = _firebaseAuth.currentUser;
      notifyListeners();
    }
  }
}