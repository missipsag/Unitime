import 'dart:ffi';

import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unitime/core/constants/uni_appointment_type.dart';
import 'package:unitime/core/constants/colors.dart';

import '../core/constants/uni_appointment_scope.dart';

class UniAppointment extends Appointment {
  final DateTime start;
  final DateTime end;
  final String title;
  final String appointmentLocation;
  final UniAppointmentType uniAppointmentType;
  final UniAppointmentScope uniAppointmentScope;
  final String recurrence;

  UniAppointment({
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
    // return switch (json) {
    //   {
    //   'id': Long id,
    //   'title': String title,
    //   'startTime': DateTime start,
    //   'endTime': DateTime end,
    //   'location': String location,
    //   'appointmentType': UniAppointmentType uniAppointmentType,
    //   'appointmentScope': UniAppointmentScope uniAppointmentScope,
    //   'recurrenceRule': String recurrence,
    //
    //   } =>
    return UniAppointment(
      title: json['id'],
      start: json['start'],
      end: json['end'],
      appointmentLocation: json['location'],
      uniAppointmentType: json['uniAppointmentType'],
      uniAppointmentScope: json['uniAppointmentType'],
      recurrence: json['uniAppointmentType'],
    );
    // _ => throw const FormatException("Failed to load appointment."),
    // };
  }
}
