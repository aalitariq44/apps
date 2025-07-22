import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';

class CoursesListScreen extends StatefulWidget {
  final VoidCallback onLanguageToggle;
  final bool showEnrolledOnly;

  const CoursesListScreen({
    super.key,
    required this.onLanguageToggle,
    this.showEnrolledOnly = false,
  });

  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> {
  List<Course> courses = [];
  List<Course> filteredCourses = [];
  String searchQuery = '';
  String selectedLevel = 'All';

  @override
  void initState() {
    super.initState();
    courses = Course.getDummyCourses();
    _filterCourses();
  }

  void _filterCourses() {
    setState(() {
      filteredCourses = courses.where((course) {
        final matchesSearch = course.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            course.instructor.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesLevel = selectedLevel == 'All' || course.level == selectedLevel;
        final matchesEnrollment = !widget.showEnrolledOnly || course.isEnrolled;
        
        return matchesSearch && matchesLevel && matchesEnrollment;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final title = widget.showEnrolledOnly
        ? (isArabic ? 'دوراتي' : 'My Courses')
        : (isArabic ? 'جميع الدورات' : 'All Courses');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2D3748)),
        actions: [
          IconButton(
            onPressed: widget.onLanguageToggle,
            icon: const Icon(Icons.language),
            tooltip: isArabic ? 'اللغة' : 'Language',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      searchQuery = value;
                      _filterCourses();
                    },
                    decoration: InputDecoration(
                      hintText: isArabic ? 'البحث عن الدورات...' : 'Search courses...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF667eea),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', isArabic ? 'الكل' : 'All'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Beginner', isArabic ? 'مبتدئ' : 'Beginner'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Intermediate', isArabic ? 'متوسط' : 'Intermediate'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Advanced', isArabic ? 'متقدم' : 'Advanced'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Courses List
          Expanded(
            child: filteredCourses.isEmpty
                ? _buildEmptyState(isArabic)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CourseCard(
                          course: filteredCourses[index],
                          isCompact: false,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = selectedLevel == value;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF667eea),
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selectedLevel = value;
        });
        _filterCourses();
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF667eea),
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFF667eea) : Colors.grey[300]!,
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF667eea).withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.school_outlined,
              size: 60,
              color: Color(0xFF667eea),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.showEnrolledOnly
                ? (isArabic ? 'لم تسجل في أي دورة بعد' : 'No enrolled courses yet')
                : (isArabic ? 'لا توجد دورات متطابقة' : 'No matching courses found'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.showEnrolledOnly
                ? (isArabic ? 'ابدأ بالتسجيل في دورة جديدة' : 'Start by enrolling in a new course')
                : (isArabic ? 'جرب تغيير معايير البحث' : 'Try changing your search criteria'),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (widget.showEnrolledOnly)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoursesListScreen(
                      onLanguageToggle: widget.onLanguageToggle,
                      showEnrolledOnly: false,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.explore),
              label: Text(isArabic ? 'استكشف الدورات' : 'Explore Courses'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
