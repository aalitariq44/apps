import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interfaces/l10n/app_localizations.dart';
import '../../core/theme.dart';
import 'models/hotel.dart';
import 'models/booking.dart';
import 'screens/login_screen.dart';
import 'screens/search_hotels_screen.dart';
import 'screens/hotel_details_screen.dart';
import 'screens/select_room_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/booking_confirmation_screen.dart';

class HotelBookingApp extends StatefulWidget {
  const HotelBookingApp({super.key});

  @override
  State<HotelBookingApp> createState() => _HotelBookingAppState();
}

class _HotelBookingAppState extends State<HotelBookingApp> {
  Locale _currentLocale = const Locale('en', '');
  bool _isDarkMode = false;
  SearchCriteria? _currentSearch;

  void _toggleLanguage() {
    setState(() {
      _currentLocale = _currentLocale.languageCode == 'en'
          ? const Locale('ar', '')
          : const Locale('en', '');
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _updateSearch(SearchCriteria search) {
    setState(() {
      _currentSearch = search;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Booking',
      theme: AppTheme.lightTheme,
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
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              builder: (context) => LoginScreen(
                onLanguageToggle: _toggleLanguage,
                onLoginSuccess: () {
                  Navigator.of(context).pushReplacementNamed('/search');
                },
              ),
            );

          case '/search':
            return MaterialPageRoute(
              builder: (context) => SearchHotelsScreen(
                onLanguageToggle: _toggleLanguage,
                onThemeToggle: _toggleTheme,
                isDarkMode: _isDarkMode,
                onSearchSubmitted: _updateSearch,
              ),
            );

          case '/hotel-details':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => HotelDetailsScreen(
                hotel: args['hotel'] as Hotel,
                searchCriteria: _currentSearch,
              ),
            );

          case '/select-room':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => SelectRoomScreen(
                hotel: args['hotel'] as Hotel,
                selectedRoom: args['room'] as Room,
                searchCriteria: args['searchCriteria'] as SearchCriteria?,
              ),
            );

          case '/booking':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => BookingScreen(
                bookingData: args['bookingData'] as BookingData,
              ),
            );

          case '/booking-confirmation':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => BookingConfirmationScreen(
                booking: args['booking'] as Booking,
              ),
            );

          default:
            return MaterialPageRoute(
              builder: (context) => LoginScreen(
                onLanguageToggle: _toggleLanguage,
                onLoginSuccess: () {
                  Navigator.of(context).pushReplacementNamed('/search');
                },
              ),
            );
        }
      },
    );
  }
}
