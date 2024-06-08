import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menk_weather/blocs/weather_bloc.dart';
import 'package:menk_weather/screens/city_selection_screen.dart';
import 'package:menk_weather/screens/home_screen.dart';
import 'package:menk_weather/screens/splash_screen.dart';
import 'package:menk_weather/screens/onboarding_screen.dart';
import 'package:menk_weather/screens/weather_detail_screen.dart';
import 'package:menk_weather/screens/previous_weather_screen.dart';
import 'package:menk_weather/utils/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menk_weather/repositories/weather_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>()!;
  }
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void changeTheme(ThemeMode themeMode) async {
    setState(() {
      _themeMode = themeMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode.toString());
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode');
    setState(() {
      switch (themeModeString) {
        case 'ThemeMode.light':
          _themeMode = ThemeMode.light;
          break;
        case 'ThemeMode.dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
          break;
      }
    });
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        name: 'splash',
        path: '/splash',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        name: 'onboarding',
        path: '/onboarding',
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        name: 'detail',
        path: '/detail/:city',
        builder: (context, state) {
          final city = state.pathParameters['city']!;
          return WeatherDetailScreen(city: city);
        },
      ),
      GoRoute(
        name: 'city_selection',
        path: '/city_selection',
        builder: (context, state) => CitySelectionScreen(),
      ),
      GoRoute(
        name: 'previous_weather',
        path: '/previous_weather',
        builder: (context, state) => PreviousWeatherScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(WeatherRepository()),
      child: MaterialApp.router(
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
      ),
    );
  }
}
