import 'package:flutter/material.dart';
import 'package:unitime/core/constants/uni_appointment_types.dart';

enum CourseColor { blue }

enum TPColor { green }

enum TDColor { orange }

Map<UniAppointmentTypes, Color> appointementColor = {
  UniAppointmentTypes.course: Colors.blue,
  UniAppointmentTypes.td : Colors.deepOrangeAccent,
  UniAppointmentTypes.tp : Colors.green,
  UniAppointmentTypes.specialEvent : Colors.purpleAccent
};
