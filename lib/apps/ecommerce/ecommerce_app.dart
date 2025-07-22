import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      onComplete: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }
}
