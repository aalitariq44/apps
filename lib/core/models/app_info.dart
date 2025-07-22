class AppInfo {
  final String id;
  final String name;
  final String description;
  final String route;
  final String imageUrl;
  final List<String> technologies;
  final String category;

  AppInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.route,
    required this.imageUrl,
    required this.technologies,
    required this.category,
  });

  static List<AppInfo> getPortfolioApps() {
    return [
      AppInfo(
        id: '1',
        name: 'E-commerce App',
        description: 'Modern e-commerce application with beautiful UI, product catalog, cart functionality, and multi-language support.',
        route: '/ecommerce',
        imageUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=500',
        technologies: ['Flutter', 'Dart', 'Material Design', 'Localization'],
        category: 'E-commerce',
      ),
      // More apps can be added here in the future
    ];
  }
}
