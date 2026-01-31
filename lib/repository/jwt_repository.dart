import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/service/jwt_service.dart';
import 'package:unitime/service/storage_service.dart';

class JwtRepository {
  static final JwtRepository _shared = JwtRepository._sharedInstance();

  JwtRepository._sharedInstance();

  factory JwtRepository() => _shared;

  final _jwtService = JwtService();
  final _storageSerice = StorageService();
  static const String _authTokenKey = "jwt_token";

  Future<Result<String?>> getToken() async {
    final token =  await _storageSerice.read(_authTokenKey);
    try {
      switch (token) {
        case Ok<String>():
          return Result.ok(token.value);

        default:
          return Result.error(CouldNotGetJWTToken());
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<bool>> isTokenExpired(String token) async {
    return await _jwtService.isTokenExpired(token);

  }
}
