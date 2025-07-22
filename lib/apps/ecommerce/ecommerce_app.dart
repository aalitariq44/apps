import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/products_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'models/cart.dart';
import 'models/product.dart';

class EcommerceApp extends StatefulWidget {
  const EcommerceApp({super.key});

  @override
  State<EcommerceApp> createState() => _EcommerceAppState();
}

class _EcommerceAppState extends State<EcommerceApp> {
  final Cart _cart = Cart();
  Locale _currentLocale = const Locale('en', '');

  void _toggleLanguage() {
    setState(() {
      _currentLocale = _currentLocale.languageCode == 'en' 
          ? const Locale('ar', '') 
          : const Locale('en', '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      onComplete: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }
}
