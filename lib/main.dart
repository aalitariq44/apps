import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interfaces/l10n/app_localizations.dart';
import 'core/theme.dart';
import 'core/models/app_info.dart';
import 'apps/ecommerce/ecommerce_app.dart';
import 'apps/ecommerce/models/cart.dart';
import 'apps/ecommerce/models/product.dart';
import 'apps/ecommerce/screens/cart_screen.dart';
import 'apps/ecommerce/screens/login_screen.dart';
import 'apps/ecommerce/screens/product_details_screen.dart';
import 'apps/ecommerce/screens/products_screen.dart';
import 'apps/ecommerce/screens/profile_screen.dart';
import 'apps/task_manager/task_manager_app.dart';
import 'apps/hotel_booking/hotel_booking_app.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interfaces Portfolio',
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
      home: PortfolioHomePage(onLanguageToggle: _toggleLanguage),
      routes: {
        '/ecommerce': (context) => const EcommerceApp(),
        '/task-manager': (context) => const TaskManagerApp(),
        '/hotel-booking': (context) => const HotelBookingApp(),
        '/login': (context) => const LoginScreen(),
        '/products': (context) => ProductsScreen(
              cart: _cart,
              onLanguageToggle: _toggleLanguage,
            ),
        '/cart': (context) => CartScreen(cart: _cart),
        '/profile': (context) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product-details') {
          final product = settings.arguments as Product?;
          if (product == null) {
            return MaterialPageRoute(
              builder: (context) => ProductsScreen(
                cart: _cart,
                onLanguageToggle: _toggleLanguage,
              ),
            ); // Or an error screen
          }
          return MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: product,
              cart: _cart,
            ),
          );
        }
        return null;
      },
    );
  }
}

class PortfolioHomePage extends StatelessWidget {
  final VoidCallback onLanguageToggle;

  const PortfolioHomePage({super.key, required this.onLanguageToggle});

  @override
  Widget build(BuildContext context) {
    final List<AppInfo> apps = AppInfo.getPortfolioApps();
    final locale = Localizations.localeOf(context);
    final appTitle =
        locale.languageCode == 'ar' ? 'معرض الواجهات' : 'Interfaces Portfolio';
    final language = locale.languageCode == 'ar' ? 'اللغة' : 'Language';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: onLanguageToggle,
                icon: const Icon(Icons.language),
                tooltip: language,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                appTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6C5CE7),
                      Color(0xFF74B9FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.apps,
                        size: 60,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Flutter UI Showcase',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: AppCard(
                          app: apps[index],
                          onTap: () {
                            Navigator.pushNamed(context, apps[index].route);
                          },
                        ),
                      ),
                    ),
                  );
                },
                childCount: apps.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final AppInfo app;
  final VoidCallback onTap;

  const AppCard({
    super.key,
    required this.app,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF8F9FA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(app.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C5CE7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          app.category,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6C5CE7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        app.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          app.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: app.technologies.take(3).map((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tech,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
