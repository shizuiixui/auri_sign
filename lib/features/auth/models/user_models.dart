class UserModel {
  final String id;
  final String firstName;
  final String email;
  final String? profilePicture;

  UserModel({
    required this.id,
    required this.firstName,
    required this.email,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? 'User',
      profilePicture: json['profilePicture'],
    );
  }
}