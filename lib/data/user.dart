import 'dart:ffi';

class User {
  final Long id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': Long id,
        'email': String email,
        'firstName': String firstName,
        'lastName': String lastName,
        'createdAt': DateTime createdAt,
        'updatedAt': DateTime updatedAt,
      } =>
        User(
          id: id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      _ => throw const FormatException("Failed to load user."),
    };
  }
}
