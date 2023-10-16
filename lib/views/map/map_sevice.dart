import 'dart:convert';
import 'package:http/http.dart' as http;

class MapService {
  Future<Map<String, dynamic>> getWeatherData(
      double lat, double lon, String apiKey) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey'));

    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);
      return weatherData;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
