import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:menk_weather/l10n/app_localizations.dart';
import 'package:menk_weather/main.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool isDarkMode = false;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    context.go('/home');
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
    final List<Map<String, String>> onboardingData = [
      {
        'title': localization.translate('welcomeMessage'),
        'description': localization.translate('detailedWeatherInfo'),
      },
      {
        'title': localization.translate('detailedWeatherInfo'),
        'description': localization.translate('stayUpdated'),
      },
      {
        'title': localization.translate('stayUpdated'),
        'description': localization.translate('getStarted'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('appTitle')),
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
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: onboardingData.length,
        itemBuilder: (context, index) {
          return OnboardingPage(
            title: onboardingData[index]['title']!,
            description: onboardingData[index]['description']!,
          );
        },
      ),
      bottomSheet: _currentPage == onboardingData.length - 1
          ? TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                localization.translate('getStarted'),
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              style: TextButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            )
          : Container(
              height: 60,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onboardingData.length, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: _currentPage == index ? 20 : 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
            ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;

  OnboardingPage({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
