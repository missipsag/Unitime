import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:unitime/core/utils/result.dart';

class JwtService {
  static final JwtService _shared = JwtService._sharedInstance();

  JwtService._sharedInstance();

  factory JwtService() => _shared;

  Future<Result<bool>> isTokenExpired(String token) async {
    try {
      return Result.ok(JwtDecoder.isExpired(token));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
