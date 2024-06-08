import 'package:flutter/material.dart';
import 'package:menk_weather/models/weather.dart';
import 'package:go_router/go_router.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  WeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(weather.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${weather.main.temp} °C'),
            Text(weather.weather[0].description),
          ],
        ),
        onTap: () {
          context.go('/detail/${weather.name}');
        },
      ),
    );
  }
}
