import 'package:ayurveda/core/api_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/shared_preference.dart';

class ApiService {
  Future<bool> login(String username, String password) async {
    final url = Uri.parse(loginUrl);
    try {
      final response = await http.post(
        url,
        body: {'username': username, 'password': password},
      );

      print('LOGIN RESPONSE STATUS => ${response.statusCode}');
      print('LOGIN RESPONSE BODY => ${response.body}');

      final Map<String, dynamic> data = jsonDecode(response.body);
      final bool status = data['status'] == true;
      if (status) {
        final String? token = data['token'] as String?;
        await saveToken(token!);
        await saveLoginStatus(true);
        return true;
      } else {
        print('LOGIN FAILED => API status=false');
        final String message =
            data['message']?.toString() ?? 'Invalid credentials';
        throw message;
      }
    } catch (e) {
      print('LOGIN EXCEPTION => $e');
      throw Exception(e.toString());
    }
  }
}
