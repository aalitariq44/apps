import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/user.dart';
import '../widgets/course_card.dart';
import 'courses_list_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  final VoidCallback onLanguageToggle;

  const HomeScreen({
    super.key,
    required this.user,
    required this.onLanguageToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final courses = Course.getDummyCourses();
    final enrolledCourses = courses.where((course) => course.isEnrolled).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: onLanguageToggle,
                icon: const Icon(Icons.language, color: Colors.white),
                tooltip: isArabic ? 'اللغة' : 'Language',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFF764ba2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 0),
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(user.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isArabic ? 'مرحباً' : 'Welcome back',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            _buildStatCard(
                              icon: Icons.book_outlined,
                              title: isArabic ? 'الدورات المسجلة' : 'Enrolled',
                              value: '${enrolledCourses.length}',
                            ),
                            const SizedBox(width: 16),
                            _buildStatCard(
                              icon: Icons.check_circle_outline,
                              title: isArabic ? 'مكتملة' : 'Completed',
                              value: '${user.completedCourses}',
                            ),
                            const SizedBox(width: 16),
                            _buildStatCard(
                              icon: Icons.star_outline,
                              title: isArabic ? 'المعدل' : 'Average',
                              value: '${user.averageScore.toStringAsFixed(0)}%',
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Actions
                Text(
                  isArabic ? 'الإجراءات السريعة' : 'Quick Actions',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.library_books,
                      title: isArabic ? 'دوراتي' : 'My Courses',
                      subtitle: isArabic ? 'عرض الدورات المسجلة' : 'View enrolled courses',
                      color: const Color(0xFF4299E1),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoursesListScreen(
                              onLanguageToggle: onLanguageToggle,
                              showEnrolledOnly: true,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildActionCard(
                      context,
                      icon: Icons.explore,
                      title: isArabic ? 'دورات جديدة' : 'New Courses',
                      subtitle: isArabic ? 'استكشف دورات جديدة' : 'Explore new courses',
                      color: const Color(0xFF48BB78),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoursesListScreen(
                              onLanguageToggle: onLanguageToggle,
                              showEnrolledOnly: false,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildActionCard(
                      context,
                      icon: Icons.quiz,
                      title: isArabic ? 'اختبارات قصيرة' : 'Quick Tests',
                      subtitle: isArabic ? 'قم بإجراء اختبار سريع' : 'Take a quick test',
                      color: const Color(0xFFED8936),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              onLanguageToggle: onLanguageToggle,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Continue Learning Section
                if (enrolledCourses.isNotEmpty) ...[
                  Text(
                    isArabic ? 'تابع التعلم' : 'Continue Learning',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...enrolledCourses.map((course) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CourseCard(
                      course: course,
                      isCompact: true,
                    ),
                  )),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8), // Reduced padding
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18, // Reduced icon size
            ),
            const SizedBox(height: 4), // Reduced spacing
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16, // Reduced font size
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10, // Reduced font size
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
