import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:unitime/core/constants/app_routes.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';

class AuthenticationService {
  static final AuthenticationService _shared =
      AuthenticationService._sharedInstance();

  AuthenticationService._sharedInstance();

  factory AuthenticationService() => _shared;

  Future<Result<String>> login(String email, String password) async {
    try {
      final res = await http
          .post(
            Uri.parse(TAppRoutes.loginRoute),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"email": email, "password": password}),
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final token = jsonDecode(res.body)['token'];

        return Result.ok(token);
      } else if (res.statusCode == 400) {
        return Result.error(BadRequestException());
      } else if (res.statusCode == 404) {
        return Result.error(UserNotFoundException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else if (res.statusCode >= 500) {
        return Result.error(
          ServerException("Failed with status code : ${res.statusCode}"),
        );
      } else {
        return Result.error(CouldNotLogInUserAuthException());
      }
    } on SocketException {
      return Result.error(NoInternetException());
    } on TimeoutException {
      return Result.error(NetworkTimeoutException());
    } on FormatException {
      return Result.error(DataParsingException());
    } on Exception catch (e) {
      return Result.error(UnknownServiceException(e.toString()));
    } catch (e, stacktrace) {
      return Result.error(UnknownServiceException(e.toString()));
    }
  }

  Future<Result<String>> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse(TAppRoutes.registerRoute),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "email": email,
              "password": password,
              "firstName": firstName,
              "lastName": lastName,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if ((res.statusCode == 200 || res.statusCode == 201) &&
          res.body.isNotEmpty) {
        final token = jsonDecode(res.body)['token'];
        return Result.ok(token);
      } else if (res.statusCode == 400) {
        return Result.error(BadRequestException());
      } else if (res.statusCode == 409) {
        return Result.error(UserAlreadyExistsException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else if (res.statusCode >= 500) {
        return Result.error(
          ServerException("Server error with status code : ${res.statusCode}"),
        );
      } else {
        return Result.error(CouldNotRegisterUserAuthException());
      }
    } on SocketException {
      return Result.error(NoInternetException());
    } on TimeoutException {
      return Result.error(NetworkTimeoutException());
    } on FormatException {
      return Result.error(DataParsingException());
    } on Exception catch (e) {
      return Result.error(UnknownServiceException(e.toString()));
    } catch (e, stacktrace) {
      return Result.error(UnknownServiceException(e.toString()));
    }
  }
}
