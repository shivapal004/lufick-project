import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthService _authService = AuthService();

  User? get user => _user;

  UserProvider() {
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> signIn() async {
    _user = await _authService.signInWithGoogle();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  void setUser(User? updatedUser) {
    _user = updatedUser;
    notifyListeners(); // Notify UI to update profile picture
  }
}
