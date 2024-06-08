import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Welcome to Menk Weather',
      'description': 'Get accurate weather forecasts for your city.'
    },
    {
      'title': 'Detailed Weather Information',
      'description':
          'See detailed weather information including temperature, humidity, and wind speed.'
    },
    {
      'title': 'Stay Updated',
      'description':
          'Receive real-time weather updates and stay prepared for any weather condition.'
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: _onboardingData.length,
        itemBuilder: (context, index) {
          return OnboardingPage(
            title: _onboardingData[index]['title']!,
            description: _onboardingData[index]['description']!,
          );
        },
      ),
      bottomSheet: _currentPage == _onboardingData.length - 1
          ? TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'Get Started',
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
                children: List.generate(_onboardingData.length, (index) {
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
