enum UniAppointmentScope {
  PROMOTION,
  GROUP,
  GLOBAL;

  String get displayName {
    return switch (this) {
      UniAppointmentScope.GLOBAL => "GLOBAL",
      UniAppointmentScope.GROUP => "GROUP",
      UniAppointmentScope.PROMOTION => "PROMOTION",
    };
  }
}
