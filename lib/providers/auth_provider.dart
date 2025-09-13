import 'package:flutter/material.dart';
import '../network/login_network.dart';
import '../core/shared_preference.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _usernameError;
  String? _passwordError;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get usernameError => _usernameError;
  String? get passwordError => _passwordError;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final api = ApiService();
      final result = await api.login(email, password);
      if (result) {
        await saveLoginStatus(true);
        return true;
      } else {
        _errorMessage = 'Invalid credentials';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUsernameError(String? message) {
    _usernameError = message;
    notifyListeners();
  }

  void setPasswordError(String? message) {
    _passwordError = message;
    notifyListeners();
  }

  void clearFieldErrors() {
    _usernameError = null;
    _passwordError = null;
    notifyListeners();
  }
}
