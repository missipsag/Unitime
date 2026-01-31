import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/promotion.dart';
import 'package:unitime/service/promotion_service.dart';

class PromotionRepository {
  static final PromotionRepository _shared =
      PromotionRepository._sharedInstance();

  PromotionRepository._sharedInstance();

  factory PromotionRepository() => _shared;

  final _promotionService = PromotionService();

  Future<Result<Promotion>> getPromotion(
    String accessCode,
    String token,
  ) async {
    return await _promotionService.getPromotion(accessCode, token);
  }

  Future<Result<Promotion>> createPromotion(
    Promotion promotion,
    String token,
  ) async {
    return await _promotionService.createPromotion(promotion, token);
  }

  Future<Result<void>> deletePromotion(String accessCode, String token) async {
    return await _promotionService.deletePromotion(accessCode, token);
  }
}
