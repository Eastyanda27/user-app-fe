import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:8000/api'; // Untuk emulator Android

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }
}
