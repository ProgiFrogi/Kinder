import 'dart:convert'; // Библиотека для джейсончика
import 'package:http/http.dart' as http;

class CatApi {
  static const String _baseUrl = 'https://api.thecatapi.com/v1';
  static const String _apiKey =
      'live_FOGUrSKP0IADYPTdbezFLZRmDSIkOnrjSULimydmzKqB6p5iZ4AT6JPz3R0HrFpF';

  Future<Map<String, dynamic>> fetchRandomCat() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/images/search?has_breeds=true'),
      headers: {'x-api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)[0];
    } else {
      throw Exception('Failed to load cat');
    }
  }
}
