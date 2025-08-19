import 'dart:async';

import 'package:unitime/core/constants/uni_appointment_types.dart';
import 'package:unitime/data/uni_appointment.dart';

class AppointmentService {
  List<UniAppointment> _appointments = [];
  static final AppointmentService _shared =
      AppointmentService._sharedInstance();
  AppointmentService._sharedInstance() {
    _appointmentStreamController =
        StreamController<List<UniAppointment>>.broadcast(
          onListen: () {
            _appointmentStreamController.sink.add(_appointments);
          },
        );
  }
  factory AppointmentService() => _shared;
  late final StreamController<List<UniAppointment>>
  _appointmentStreamController;

  Future<void> createAppointment({
    required DateTime start,
    required DateTime end,
    required String uniAppointmentSubject,
    required int roomNum,
    required UniAppointmentTypes type,
  }) async {
    final newAppointment = UniAppointment(
      start: start,
      end: end,
      uniAppointmentSubject: uniAppointmentSubject,
      roomNum: roomNum,
      type: type,
    );
    _appointments.add(newAppointment);
  }

  Stream<List<UniAppointment>> get allAppointments => _appointmentStreamController.stream.map((appointment) => appointment);
}
