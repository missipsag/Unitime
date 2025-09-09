import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unitime/core/constants/uni_appointment_types.dart';
import 'package:unitime/core/constants/colors.dart';

class UniAppointment extends Appointment {
  final DateTime start;
  final DateTime end;
  final String uniAppointmentSubject;
  final String uniappointmentLocation;
  final UniAppointmentTypes type;
  final String recurrence;

  UniAppointment({
    required this.start,
    required this.end,
    required this.uniAppointmentSubject,
    required this.uniappointmentLocation,
    required this.type,
    required this.recurrence
  }) : super(
         startTime: start,
         endTime: end,
         subject: uniAppointmentSubject,
         color: appointementColor[type] as Color,
         recurrenceRule: recurrence,
         location: uniappointmentLocation
       );
}
