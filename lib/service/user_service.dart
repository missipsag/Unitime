import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/user.dart';

class UserService {
  UserService();

  Future<Result<User>> getUser(String token) async {
    try {
      final res = await http.get(
        Uri.parse("http://localhost:8080/api/users/me"),
        headers: {'Authorization ': 'Bearer $token'}
      );

      if (res.statusCode == 200) {
        final currUser = jsonDecode(res.body);
        return Result.ok(
          User(
            id: currUser!.id,
            email: currUser!.email,
            firstName: currUser!.firstName,
            lastName: currUser!.lastName,
            createdAt: currUser!.createdAt,
            updatedAt: currUser!.updatedAt,
          ),
        );
      } else {
        return Result.error(CouldNotGetUserException());
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<User>> updateUser(User user, String token) async {
    try {
      final res = await http.put(
        Uri.parse("http://localhost:8080/api/users/edit"),
        body: jsonEncode(user),
        headers: {'Authorization': 'Bearer $token'}
      );

      if (res.statusCode == 200) {
        final editedUser = jsonDecode(res.body);

        return Result.ok(
          User(
            id: editedUser!.id,
            email: editedUser!.email,
            firstName: editedUser!.firstName,
            lastName: editedUser!.lastName,
            createdAt: editedUser!.createdAt,
            updatedAt: editedUser!.updatedAt,
          ),
        );
      } else {
        return Result.error(CouldNotUpdateUserException());
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
