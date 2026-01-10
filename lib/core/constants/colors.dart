import 'package:flutter/material.dart';
import 'package:unitime/core/constants/uni_appointment_type.dart';

enum CourseColor { blue }

enum TPColor { green }

enum TDColor { orange }

Map<UniAppointmentType, Color> appointementColor = {
  UniAppointmentType.COURSE: const Color.fromARGB(255, 71, 163, 239),
  UniAppointmentType.TD: const Color.fromARGB(255, 255, 138, 102),
  UniAppointmentType.TP: const Color.fromARGB(255, 96, 226, 100),
  UniAppointmentType.SPECIAL_EVENT: const Color.fromARGB(255, 234, 118, 255),
};
