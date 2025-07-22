class User {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final List<String> enrolledCourses;
  final int completedCourses;
  final int totalQuizzesTaken;
  final double averageScore;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.enrolledCourses,
    required this.completedCourses,
    required this.totalQuizzesTaken,
    required this.averageScore,
  });

  static User getDummyUser() {
    return User(
      id: '1',
      name: 'أحمد محمد',
      email: 'ahmed@example.com',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
      enrolledCourses: ['1', '2'],
      completedCourses: 1,
      totalQuizzesTaken: 3,
      averageScore: 85.5,
    );
  }
}
