import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menk_weather/blocs/weather_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:menk_weather/widgets/weather_list.dart';
import 'package:menk_weather/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:menk_weather/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
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
    final state = GoRouter.of(context).routerDelegate.currentConfiguration;

    if (state is! RouteMatchList) {
      return Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context)!.translate('invalidState')),
        ),
      );
    }

    final lastState = state.uri.queryParameters;
    final city = lastState['city'];

    if (city != null) {
      BlocProvider.of<WeatherBloc>(context).add(FetchWeather(city));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('appTitle')),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              context.go('/city_selection');
            },
          ),
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
      body: WeatherList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.history),
        onPressed: () {
          context.go('/previous_weather');
        },
      ),
    );
  }
}
