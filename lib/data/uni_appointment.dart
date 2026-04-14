import 'package:unitime/core/constants/uni_appointment_type.dart';

import '../core/constants/uni_appointment_scope.dart';

class UniAppointment {
  @override
  final int id;
  final DateTime start;
  final DateTime end;
  final String title;
  final String appointmentLocation;
  final UniAppointmentType uniAppointmentType;
  final UniAppointmentScope uniAppointmentScope;
  final String? recurrence;

  UniAppointment({
    required this.id,
    required this.start,
    required this.end,
    required this.title,
    required this.appointmentLocation,
    required this.uniAppointmentType,
    required this.uniAppointmentScope,
    this.recurrence,
  });

  factory UniAppointment.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String title,
        'startTime': String start,
        'endTime': String end,
        'location': String location,
        'appointmentType': String uniAppointmentTypeString,
        'appointmentScope': String uniAppointmentScopeString,
        'recurrenceRule': String? recurrence,
        // 'createdBy': Map<String, dynamic>? _,
      } =>
        UniAppointment(
          id: id,
          title: title,
          start: DateTime.parse(start),
          end: DateTime.parse(end),
          appointmentLocation: location,
          uniAppointmentType: UniAppointmentType.values.firstWhere(
            (name) => name.displayName == uniAppointmentTypeString,
          ),
          uniAppointmentScope: UniAppointmentScope.values.firstWhere(
            (name) => name.displayName == uniAppointmentScopeString,
          ),
          recurrence: recurrence,
        ),
      _ => throw const FormatException("Failed to load appointment."),
    };
  }
}
