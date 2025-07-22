class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime joinDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.joinDate,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    DateTime? joinDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      joinDate: joinDate ?? this.joinDate,
    );
  }

  // Dummy user data for demonstration
  static User getDummyUser() {
    return User(
      id: 'user_1',
      name: 'Ahmed Ali',
      email: 'ahmed.ali@example.com',
      avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      joinDate: DateTime.now().subtract(const Duration(days: 30)),
    );
  }
}
