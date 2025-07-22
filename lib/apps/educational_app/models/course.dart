class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String imageUrl;
  final List<String> lessons;
  final int duration; // in hours
  final double rating;
  final int studentsCount;
  final String level;
  final bool isEnrolled;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.imageUrl,
    required this.lessons,
    required this.duration,
    required this.rating,
    required this.studentsCount,
    required this.level,
    this.isEnrolled = false,
  });

  static List<Course> getDummyCourses() {
    return [
      Course(
        id: '1',
        title: 'Flutter Development',
        description: 'Learn to build beautiful mobile apps with Flutter and Dart. This comprehensive course covers everything from basics to advanced topics.',
        instructor: 'Ahmed Ali',
        imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=500',
        lessons: [
          'Introduction to Flutter',
          'Dart Programming Basics',
          'Widgets and Layouts',
          'State Management',
          'Navigation',
          'API Integration',
          'Publishing Apps'
        ],
        duration: 25,
        rating: 4.8,
        studentsCount: 2340,
        level: 'Beginner',
        isEnrolled: true,
      ),
      Course(
        id: '2',
        title: 'UI/UX Design Principles',
        description: 'Master the art of user interface and user experience design. Learn design thinking, prototyping, and creating beautiful interfaces.',
        instructor: 'Sara Mohamed',
        imageUrl: 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=500',
        lessons: [
          'Design Thinking',
          'Color Theory',
          'Typography',
          'Layout Principles',
          'Prototyping',
          'User Research',
          'Usability Testing'
        ],
        duration: 18,
        rating: 4.9,
        studentsCount: 1850,
        level: 'Intermediate',
      ),
      Course(
        id: '3',
        title: 'Mobile App Design',
        description: 'Design stunning mobile applications that users love. Focus on mobile-first design principles and best practices.',
        instructor: 'Omar Hassan',
        imageUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=500',
        lessons: [
          'Mobile Design Patterns',
          'iOS Design Guidelines',
          'Android Material Design',
          'Responsive Design',
          'Accessibility',
          'Animation Principles'
        ],
        duration: 15,
        rating: 4.7,
        studentsCount: 1420,
        level: 'Advanced',
      ),
      Course(
        id: '4',
        title: 'Programming Fundamentals',
        description: 'Build a strong foundation in programming concepts. Perfect for beginners starting their coding journey.',
        instructor: 'Fatima Al-Zahra',
        imageUrl: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=500',
        lessons: [
          'Programming Concepts',
          'Variables and Data Types',
          'Control Structures',
          'Functions',
          'Object-Oriented Programming',
          'Problem Solving'
        ],
        duration: 20,
        rating: 4.6,
        studentsCount: 3200,
        level: 'Beginner',
      ),
      Course(
        id: '5',
        title: 'Web Development Basics',
        description: 'Learn the fundamentals of web development with HTML, CSS, and JavaScript. Build your first websites.',
        instructor: 'Khalid Ibrahim',
        imageUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=500',
        lessons: [
          'HTML Structure',
          'CSS Styling',
          'JavaScript Basics',
          'Responsive Design',
          'DOM Manipulation',
          'Project Building'
        ],
        duration: 22,
        rating: 4.5,
        studentsCount: 2780,
        level: 'Beginner',
      ),
    ];
  }
}
