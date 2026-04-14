import 'package:unitime/core/constants/user_role.dart';
import 'package:unitime/data/group.dart';
import 'package:unitime/data/promotion.dart';

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  Group? group;
  Promotion? promotion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<UserRole> roles;
  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
    this.group,
    this.promotion,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'email': String email,
        'firstName': String firstName,
        'lastName': String lastName,
        'group': Map<String, dynamic>? group,
        'promotion': Map<String, dynamic>? promotion,
        'roles': List<dynamic> roles,
        'createdAt': String createdAt,
        'updatedAt': String updatedAt,
      } =>
        User(
          id: id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          group: group != null ? Group.fromJson(group) : null,
          promotion: promotion != null ? Promotion.fromJson(promotion) : null,
          createdAt: DateTime.parse(createdAt),
          updatedAt: DateTime.parse(updatedAt),
          roles: roles.map((e) {
            return UserRole.values.firstWhere(
              (role) => role.name.toLowerCase() == e.toString().toLowerCase(),
              orElse: () => throw FormatException("Unknown role $e"),
            );
          }).toList(),
        ),
      _ => throw const FormatException("Failed to load user."),
    };
  }
}
