enum UserRole {
  STUDENT,
  GROUP_ADMIN,
  PROMOTION_ADMIN,
  SUPER_ADMIN;

  String get displayName {
    return switch (this) {
      UserRole.STUDENT => "STUDENT",
      UserRole.GROUP_ADMIN => "GROUP_ADMIN",
      UserRole.PROMOTION_ADMIN => "PROMOTION_ADMIN",
      UserRole.SUPER_ADMIN => "SUPER_ADMIN",
    };
  }
}
