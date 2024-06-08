import 'package:flutter/material.dart';

class WeatherDetailScreen extends StatelessWidget {
  final String city;

  const WeatherDetailScreen({Key? key, required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Details for $city'),
      ),
      body: Center(
        child: Text('Details for $city'),
      ),
    );
  }
}
