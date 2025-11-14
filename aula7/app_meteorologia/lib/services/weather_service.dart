import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherService {
  static const _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const _params = 'temperature_2m,wind_speed_10m,relative_humidity_2m';

  static Future<WeatherData> fetchWeatherData({
    required String latitude,
    required String longitude,
  }) async {
    final url =
        '$_baseUrl?latitude=$latitude&longitude=$longitude&hourly=$_params';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Erro ${response.statusCode}: Falha ao carregar dados');
      }

      return WeatherData.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }
}
