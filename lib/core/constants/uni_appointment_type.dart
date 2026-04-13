enum UniAppointmentType {
  COURSE,
  TD,
  TP,
  TEST,
  EXAM,
  SPECIAL_EVENT;

  String get displayName {
    return switch (this) {
      UniAppointmentType.COURSE => "COURSE",
      UniAppointmentType.TD => "TD",
      UniAppointmentType.TP => "TP",
      UniAppointmentType.SPECIAL_EVENT => "SPECIAL_EVENT",
      UniAppointmentType.EXAM => "EXAM",
      UniAppointmentType.TEST => "TEST",
    };
  }
}
