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
    return Promotion(
      id: json['id'],
      name: json['name'],
      field: json['field'],
      promotionLevel: json['promotionLevel'],
    );
  }
}
