import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/service/authentication_service.dart';
import 'package:unitime/service/storage_service.dart';

class AuthenticationRepository {
  static final AuthenticationRepository _shared =
      AuthenticationRepository._sharedInstance();

  AuthenticationRepository._sharedInstance();

  factory AuthenticationRepository() => _shared;
  final _storageService = StorageService();
  final _authService = AuthenticationService();
  static const String _authTokenKey = "jwt_token";

  Future<Result<void>> login(String username, String password) async {
    try {
      final token = await _authService.login(username, password);
      switch (token) {
        case Ok<String>():
          {
            await _storageService.write(_authTokenKey, token.toString());
            return Result.ok(null);
          }

        default:
          return token;
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> register(
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
            await _storageService.write(_authTokenKey, token.toString());
            return Result.ok(null);
          }

        default:
          {
            return token;
          }
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> logout() async {
    try {
      final result = await _storageService.delete(_authTokenKey);
      if (result is Ok) return result;
      return Result.error(CouldNotLogOutUserAuthException());
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
