import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/promotion.dart';

class PromotionService {
  static final PromotionService _shared = PromotionService._sharedInstance();

  PromotionService._sharedInstance();

  factory PromotionService() => _shared;

  Future<Result<Promotion>> getPromotion(int promotionId) async {
    try {
      final res = await http.get(
        Uri.parse("http://localhost:8080/api/promotions/get"),
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
        return Result.error(Exception("Failed to get promotion."));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Promotion>> createPromotion(Promotion promotion) async {
    try {
      final res = await http.post(
        Uri.parse("http://localhost:8080/api/promotions/create"),
        body: jsonEncode(promotion),
      );

      if (res.statusCode == 200) {
        final promotion = jsonDecode(res.body);
        return Result.ok(Promotion.fromJson(promotion));
      } else {
        return Result.error(Exception("Failed to create promotion"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deletePromotion(String accessCode) async {
    try {
      final res = await http.delete(
        Uri.parse("http://localhost:8080/api/promotions/delete"),
      );

      if (res.statusCode == 200) {
        return Result.ok(null);
      } else {
        return Result.error(Exception("Failed to delete promotion"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
