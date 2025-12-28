import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<bool> login(String email, String password) async {
    final user = await AuthService.login(email, password);
    if (user == null) return false;

    _user = user;
    notifyListeners();
    return true;
  }

  Future<bool> register(
      String name, String email, String password, String image) async {
    final user = await AuthService.register(name, email, password, image);
    if (user == null) return false;

    _user = user;
    notifyListeners();
    return true;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
