import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unitime/core/utils/result.dart';

class AuthenticationService {
  static final AuthenticationService _shared =
      AuthenticationService._sharedInstance();

  AuthenticationService._sharedInstance();

  factory AuthenticationService() => _shared;

  Future<Result<void>> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("http://localhost:8080/api/authentication/login"),
        body: {"email": email, "password": password},
      );

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final token = jsonDecode(res.body)['token'];

        return Result.ok(token);
      } else {
        return Result.error(Exception("Login failed"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String>> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final res = await http.post(
        Uri.parse("http://localhost:8080/api/authentication/register"),
        body: {
          "email": email,
          "password": password,
          "firstName": firstName,
          "lastName": lastName,
        },
      );

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final token = jsonDecode(res.body)['token'];
        return Result.ok(token);
      } else {
        return Result.error(Exception("Register failed"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
