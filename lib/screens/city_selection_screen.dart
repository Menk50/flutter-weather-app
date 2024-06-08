import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:go_router/go_router.dart';

class CitySelectionScreen extends StatefulWidget {
  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    final String response = await rootBundle.loadString('assets/cities.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      cities = data.map((city) => city.toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a City'),
      ),
      body: cities.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cities[index]),
                  onTap: () {
                    context.go('/home?city=${cities[index]}');
                  },
                );
              },
            ),
    );
  }
}
