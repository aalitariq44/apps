import 'package:flutter/material.dart';
import '../models/user.dart';

class SideBar extends StatelessWidget {
  final User user;
  final VoidCallback onLanguageToggle;

  const SideBar({
    super.key,
    required this.user,
    required this.onLanguageToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.name),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user.imageUrl),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF667eea),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(isArabic ? 'الرئيسية' : 'Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: Text(isArabic ? 'دوراتي' : 'My Courses'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.explore),
            title: Text(isArabic ? 'استكشاف' : 'Explore'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: Text(isArabic ? 'اختبارات' : 'Quizzes'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(isArabic ? 'الإعدادات' : 'Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(isArabic ? 'تغيير اللغة' : 'Change Language'),
            onTap: onLanguageToggle,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(isArabic ? 'تسجيل الخروج' : 'Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
