import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:menk_weather/models/weather.dart';

class WeatherRepository {
  final String apiKey = '3f175d097c280e35c77828f3eb64d5e5';

  Future<Weather> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final weather = Weather.fromJson(json);

      // Fetch edilen veriyi yerel depolamaya kaydet
      await _saveWeatherToLocalStorage(weather);

      return weather;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<Weather>> getSavedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final String? weatherData = prefs.getString('weather_data');

    if (weatherData != null) {
      final List<dynamic> weatherList = jsonDecode(weatherData);
      final List<Weather> weathers =
          weatherList.map((json) => Weather.fromJson(json)).toList();

      final uniqueWeathers = <String, Weather>{};
      for (var weather in weathers) {
        uniqueWeathers[weather.name] = weather;
      }

      return uniqueWeathers.values.toList();
    }

    return [];
  }

  Future<void> _saveWeatherToLocalStorage(Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Weather> savedWeather = await getSavedWeather();

    // Aynı şehrin verisinin olup olmadığını kontrol et
    final existingWeatherIndex =
        savedWeather.indexWhere((w) => w.name == weather.name);
    if (existingWeatherIndex != -1) {
      // Aynı şehir varsa, mevcut veriyi güncelle
      savedWeather[existingWeatherIndex] = weather;
    } else {
      // Aynı şehir yoksa, yeni veriyi ekle
      savedWeather.add(weather);
    }

    // Verileri JSON formatına çevir ve kaydet
    final String weatherData =
        jsonEncode(savedWeather.map((w) => w.toJson()).toList());
    await prefs.setString('weather_data', weatherData);
  }
}
