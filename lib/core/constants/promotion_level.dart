enum PromotionLevel {
  L1,
  L2,
  L3,
  M1,
  M2,
  D1,
  D2,
  D3;

  String get displayName {
    return switch (this) {
      PromotionLevel.L1 => "L1",
      PromotionLevel.L2 => "L2",
      PromotionLevel.L3 => "L3",
      PromotionLevel.M1 => "M1",
      PromotionLevel.M2 => "M2",
      PromotionLevel.D1 => "D1",
      PromotionLevel.D2 => "D2",
      PromotionLevel.D3 => "D3",
    };
  }
}
