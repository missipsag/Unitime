import 'dart:async';
import 'dart:convert';

import 'package:unitime/core/constants/uni_appointment_type.dart';
import 'package:unitime/data/uni_appointment.dart';
import 'package:http/http.dart' as http;

class UniAppointmentService {
  List<UniAppointment> _appointments = [];
  static final UniAppointmentService _shared =
      UniAppointmentService._sharedInstance();

  UniAppointmentService._sharedInstance() {
    _appointmentStreamController =
        StreamController<List<UniAppointment>>.broadcast(
          onListen: () {
            _appointmentStreamController.sink.add(_appointments);
          },
        );
  }

  factory UniAppointmentService() => _shared;
  late final StreamController<List<UniAppointment>>
  _appointmentStreamController;

  Future<List<UniAppointment>> get getAppointments async {
    final res = await http.get(
      Uri.parse("http://localhost:8080/api/appointments/get"),
    );

    if (res.statusCode == 200 && res.body.isNotEmpty) {
      List<dynamic> allAppointments = jsonDecode(res.body);
      return allAppointments
          .map((app) => UniAppointment.fromJson(app))
          .toList();
    } else {
      throw Exception("Failed to fetch appointments");
    }
  }
}
