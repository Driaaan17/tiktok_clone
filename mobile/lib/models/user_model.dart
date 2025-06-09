class User {
  final int id;
  final String username;
  final String email;
  final String? profileImage;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final bool isVerified;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    this.bio,
    required this.followersCount,
    required this.followingCount,
    required this.isVerified,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profile_image'],
      bio: json['bio'],
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}