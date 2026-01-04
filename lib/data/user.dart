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
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
