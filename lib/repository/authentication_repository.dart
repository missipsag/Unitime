import 'package:unitime/core/constants/env_config.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/user.dart';
import 'package:unitime/service/authentication_service.dart';
import 'package:unitime/service/storage_service.dart';
import 'package:unitime/service/user_service.dart';

class AuthenticationRepository {
  static final AuthenticationRepository _shared =
      AuthenticationRepository._sharedInstance();

  AuthenticationRepository._sharedInstance();

  factory AuthenticationRepository() => _shared;
  final _storageService = StorageService();
  final _authService = AuthenticationService();
  final _userService = UserService();
  static const String _authTokenKey = EnvConfig.authTokenKey;

  Future<Result<User>> login(String username, String password) async {
    try {
      final token = await _authService.login(username, password);
      switch (token) {
        case Ok<String>():
          {
            await _storageService.write(_authTokenKey, token.value);
            final res = await _userService.getUser(token.value);
            if (res is Ok<User>) {
              return Result.ok(res.value);
            } else {
              return res;
            }
          }

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<User>> register(
    String username,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final token = await _authService.register(
        username,
        password,
        firstName,
        lastName,
      );

      switch (token) {
        case Ok<String>():
          {
            await _storageService.write(_authTokenKey, token.value);
            final res = await _userService.getUser(token.value);
            if (res is Ok<User>) {
              return Result.ok(res.value);
            } else {
              return res;
            }
          }

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> logout() async {
    try {
      final result = await _storageService.delete(_authTokenKey);
      switch (result) {
        case Ok<void>():
          return Result.ok(null);

        case Error<void>():
          return Result.error(CouldNotLogOutUserAuthException());
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
