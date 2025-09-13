import 'package:shared_preferences/shared_preferences.dart';

/// Save login status
Future<void> saveLoginStatus(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', value);
}

/// Get login status
Future<bool> getLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

/// Save token
Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

/// Get token
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}
