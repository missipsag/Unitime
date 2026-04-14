import 'package:unitime/core/constants/env_config.dart';
import 'package:unitime/core/constants/promotion_level.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/promotion.dart';
import 'package:unitime/data/study_field.dart';
import 'package:unitime/service/promotion_service.dart';
import 'package:unitime/service/storage_service.dart';

class PromotionRepository {
  static final PromotionRepository _shared =
      PromotionRepository._sharedInstance();

  PromotionRepository._sharedInstance();

  factory PromotionRepository() => _shared;

  final PromotionService _promotionService = PromotionService();
  final StorageService _storageService = StorageService();
  final String _authTokenKey = EnvConfig.authTokenKey;

  Future<Result<Promotion>> getPromotion(String accessCode) async {
    try {
      final token = await _storageService.read(_authTokenKey);
      switch (token) {
        case Ok<String>():
          return await _promotionService.getPromotion(accessCode, token.value);

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Promotion>> createPromotion(
    String name,
    String accessCode,
    PromotionLevel level,
    StudyField field,
  ) async {
    try {
      final token = await _storageService.read(_authTokenKey);

      switch (token) {
        case Ok<String>():
          return await _promotionService.createPromotion(
            name,
            field,
            level,
            accessCode,
            token.value,
          );

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deletePromotion(String accessCode) async {
    try {
      final token = await _storageService.read(_authTokenKey);
      switch (token) {
        case Ok<String>():
          return await _promotionService.deletePromotion(
            accessCode,
            token.value,
          );

        default:
          return Result.error(UserNotAuthenticatedAuthException());
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
