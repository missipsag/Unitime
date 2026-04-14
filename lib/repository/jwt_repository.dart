import 'package:unitime/core/constants/env_config.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/service/jwt_service.dart';
import 'package:unitime/service/storage_service.dart';

class JwtRepository {
  static final JwtRepository _shared = JwtRepository._sharedInstance();

  JwtRepository._sharedInstance();

  factory JwtRepository() => _shared;

  final _jwtService = JwtService();
  final _storageService = StorageService();
  final String _authTokenKey = EnvConfig.authTokenKey;

  Future<Result<String?>> getToken() async {
    final token = await _storageService.read(_authTokenKey);
    try {
      switch (token) {
        case Ok<String>():
          return Result.ok(token.value);

        default:
          return Result.error(CouldNotGetJWTException());
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deleteToken() async {
    return await _storageService.delete(_authTokenKey);
  }

  Future<Result<bool>> isTokenExpired(String token) async {
    return await _jwtService.isTokenExpired(token);
  }
}
