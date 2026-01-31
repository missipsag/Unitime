import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/promotion.dart';

class PromotionService {
  static final PromotionService _shared = PromotionService._sharedInstance();

  PromotionService._sharedInstance();

  factory PromotionService() => _shared;

  Future<Result<Promotion>> getPromotion(
    String accessCode,
    String token,
  ) async {
    try {
      final res = await http.post(
        Uri.parse("http://localhost:8080/api/promotions/get"),
        body: jsonEncode(accessCode),
        headers: {'Authorization': 'Bearer $token'}
      );

      if (res.statusCode == 200) {
        final promotion = jsonDecode(res.body);
        return Result.ok(
          Promotion(
            id: promotion!.id,
            name: promotion!.name,
            field: promotion!.field,
            promotionLevel: promotion!.promotionLevel,
          ),
        );
      } else {
        return Result.error(CouldNotGetPromotionException());
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Promotion>> createPromotion(
    Promotion promotion,
    String token,
  ) async {
    try {
      final res = await http.post(
        Uri.parse("http://localhost:8080/api/promotions/create"),
        body: jsonEncode(promotion),
        headers: {'Authorization': 'Bearer $token'}
      );

      if (res.statusCode == 200) {
        final promotion = jsonDecode(res.body);
        return Result.ok(Promotion.fromJson(promotion));
      } else {
        return Result.error(CouldNotCreatePromotionException());
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deletePromotion(String accessCode, String token) async {
    try {
      final res = await http.delete(
        Uri.parse("http://localhost:8080/api/promotions/delete"),
        headers: {'Authorization': 'Bearer $token'}
      );

      if (res.statusCode == 200) {
        return Result.ok(null);
      } else {
        return Result.error(CouldNotDeletePromotionException());
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
