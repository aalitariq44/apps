import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interfaces/l10n/app_localizations.dart';
import '../../core/theme.dart';
import 'models/user.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';

class EducationalApp extends StatefulWidget {
  const EducationalApp({super.key});

  @override
  State<EducationalApp> createState() => _EducationalAppState();
}

class _EducationalAppState extends State<EducationalApp> {
  Locale _currentLocale = const Locale('en', '');
  bool _isLoggedIn = false;
  User? _currentUser;

  void _toggleLanguage() {
    setState(() {
      _currentLocale = _currentLocale.languageCode == 'en'
          ? const Locale('ar', '')
          : const Locale('en', '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Educational App',
      theme: AppTheme.lightTheme.copyWith(
        // Customize theme for softer colors
        colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
          primary: const Color(0xFF667eea),
          secondary: const Color(0xFF764ba2),
          surface: const Color(0xFFF8F9FA),
          background: const Color(0xFFF8F9FA),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2D3748)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF667eea),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF667eea),
            side: const BorderSide(color: Color(0xFF667eea)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
        textTheme: AppTheme.lightTheme.textTheme.copyWith(
          headlineLarge: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
          ),
          titleLarge: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w600,
          ),
          titleMedium: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w600,
          ),
          titleSmall: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      locale: _currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      home: _isLoggedIn && _currentUser != null
          ? HomeScreen(
              user: _currentUser!,
              onLanguageToggle: _toggleLanguage,
            )
          : SignupScreen(onLanguageToggle: _toggleLanguage),
    );
  }
}
