import 'package:flutter/material.dart';
import 'package:unitime/core/constants/uni_appointment_type.dart';

enum CourseColor { blue }

enum TPColor { green }

enum TDColor { orange }

Map<UniAppointmentType, Color> appointementColor = {
  UniAppointmentType.COURSE: Colors.blue,
  UniAppointmentType.TD: Colors.deepOrangeAccent,
  UniAppointmentType.TP: Colors.green,
  UniAppointmentType.SPECIAL_EVENT: Colors.purpleAccent,
};
