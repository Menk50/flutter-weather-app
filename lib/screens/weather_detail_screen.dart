import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:menk_weather/l10n/app_localizations.dart';

class WeatherDetailScreen extends StatefulWidget {
  final String city;

  const WeatherDetailScreen({Key? key, required this.city}) : super(key: key);

  @override
  _WeatherDetailScreenState createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final apiKey = '3f175d097c280e35c77828f3eb64d5e5';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=${widget.city}&units=metric&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final weatherDetailsFor = localization
        .translate('weatherDetailsFor')
        .replaceAll('{0}', widget.city);

    return Scaffold(
      appBar: AppBar(
        title: Text(weatherDetailsFor),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Text(localization.translate('errorLoadingWeather')))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        weatherDetailsFor,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      if (weatherData != null) ...[
                        Image.network(
                          'https://openweathermap.org/img/w/${weatherData!['weather'][0]['icon']}.png',
                        ),
                        SizedBox(height: 20),
                        Text(
                          localization.translate('temperature') +
                              ": ${weatherData!['main']['temp']}°C",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          localization.translate('humidity') +
                              ": ${weatherData!['main']['humidity']}%",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          localization.translate('windSpeed') +
                              ": ${weatherData!['wind']['speed']} km/h",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          localization.translate('description') +
                              ": ${weatherData!['weather'][0]['description']}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                      SizedBox(height: 20),
                      Text(
                        localization.translate('additionalInfo'),
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.go('/home');
                        },
                        child: Text(localization.translate('back')),
                      ),
                    ],
                  ),
                ),
    );
  }
}
