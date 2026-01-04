import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService {
  static final AuthenticationService _shared =
      AuthenticationService._sharedInstance();

  AuthenticationService._sharedInstance();

  factory AuthenticationService() => _shared;

  final storage = FlutterSecureStorage();
  String? token;

  Future<void> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("http://localhost:8080/api/authentication/login"),
      body: {"email": email, "password": password},
    );

    if (res.statusCode == 200 && res.body.isNotEmpty) {
      token = jsonDecode(res.body)['token'];
      storage.write(key: "token", value: token);
    } else {
      throw Exception("Login failed");
    }
  }

  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
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
      token = jsonDecode(res.body)['token'];
      storage.write(key: "token", value: token);
    } else {
      throw Exception("Register failed");
    }
  }
}
