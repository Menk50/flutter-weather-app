import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkOnboarding(context);
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _checkOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final bool? onboardingComplete = prefs.getBool('onboardingComplete');

    if (onboardingComplete == null || !onboardingComplete) {
      context.go('/onboarding');
    } else {
      context.go('/home');
    }
  }
}
