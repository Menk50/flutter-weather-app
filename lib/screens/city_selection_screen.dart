import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:menk_weather/l10n/app_localizations.dart';
import 'package:menk_weather/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitySelectionScreen extends StatefulWidget {
  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  List<String> cities = [];
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadCities();
    _loadThemePreference();
  }

  Future<void> _loadCities() async {
    final String response = await rootBundle.loadString('assets/cities.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      cities = data.map((city) => city.toString()).toList();
    });
  }

  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode');
    setState(() {
      if (themeModeString == 'ThemeMode.dark') {
        isDarkMode = true;
      } else {
        isDarkMode = false;
      }
    });
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    if (isDarkMode) {
      MyApp.of(context).changeTheme(ThemeMode.dark);
    } else {
      MyApp.of(context).changeTheme(ThemeMode.light);
    }
  }

  void _changeLanguage(Locale locale) {
    MyApp.of(context).changeLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('selectCity')),
        actions: [
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              _toggleTheme();
            },
          ),
          DropdownButton<Locale>(
            icon: Icon(Icons.language),
            onChanged: (Locale? locale) {
              if (locale != null) {
                _changeLanguage(locale);
              }
            },
            items: [
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('tr'),
                child: Text('Türkçe'),
              ),
            ],
          ),
        ],
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
