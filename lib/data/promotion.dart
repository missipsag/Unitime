import 'dart:ffi';

import 'package:unitime/core/constants/promotion_level.dart';

class Promotion {
  final Long id;
  final String name;
  final String field;
  final PromotionLevel promotionLevel;

  Promotion({
    required this.id,
    required this.name,
    required this.field,
    required this.promotionLevel,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': Long id,
        'name': String name,
        'field': String field,
        'promotionLevel': PromotionLevel promotionLevel,
      } =>
        Promotion(
          id: id,
          name: name,
          field: field,
          promotionLevel: promotionLevel,
        ),
      _ => throw const FormatException("Failed to load promotion"),
    };
  }
}
