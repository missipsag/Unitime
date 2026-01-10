
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unitime/core/constants/colors.dart';
import 'package:unitime/core/constants/uni_appointment_type.dart';

import '../core/constants/uni_appointment_scope.dart';

class UniAppointment extends Appointment {
  @override
  final int id;
  final DateTime start;
  final DateTime end;
  final String title;
  final String appointmentLocation;
  final UniAppointmentType uniAppointmentType;
  final UniAppointmentScope uniAppointmentScope;
  final String recurrence;

  UniAppointment({
    required this.id,
    required this.start,
    required this.end,
    required this.title,
    required this.appointmentLocation,
    required this.uniAppointmentType,
    required this.uniAppointmentScope,
    required this.recurrence,
  }) : super(
         startTime: start,
         endTime: end,
         subject: title,
         color: appointementColor[uniAppointmentType] as Color,
         recurrenceRule: recurrence,
         location: appointmentLocation,
       );

  factory UniAppointment.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String title,
        'startTime': DateTime start,
        'endTime': DateTime end,
        'location': String location,
        'appointmentType': UniAppointmentType uniAppointmentType,
        'appointmentScope': UniAppointmentScope uniAppointmentScope,
        'recurrenceRule': String recurrence,
      } =>
        UniAppointment(
          id: id,
          title: title,
          start: start,
          end: end,
          appointmentLocation: location,
          uniAppointmentType: uniAppointmentType,
          uniAppointmentScope: uniAppointmentScope,
          recurrence: recurrence,
        ),
      _ => throw const FormatException("Failed to load appointment."),
    };
  }
}
