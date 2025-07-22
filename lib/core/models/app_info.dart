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
      AppInfo(
        id: '2',
        name: 'Task Manager',
        description: 'Professional task management application with priority system, due dates, status tracking, and comprehensive settings.',
        route: '/task-manager',
        imageUrl: 'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=500',
        technologies: ['Flutter', 'Dart', 'Material Design', 'Animations'],
        category: 'Productivity',
      ),
      AppInfo(
        id: '3',
        name: 'Hotel Booking',
        description: 'Complete hotel reservation system with search functionality, detailed hotel views, room selection, and booking management.',
        route: '/hotel-booking',
        imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=500',
        technologies: ['Flutter', 'Dart', 'Material Design', 'Animations', 'Forms'],
        category: 'Travel & Hospitality',
      ),
      // More apps can be added here in the future
    ];
  }
}
