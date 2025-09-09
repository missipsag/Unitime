import 'dart:async';

import 'package:unitime/core/constants/uni_appointment_types.dart';
import 'package:unitime/data/uni_appointment.dart';

class AppointmentService {
  List<UniAppointment> _appointments = [
    // --- Cours ---
    UniAppointment(
      start: DateTime(2025, 9, 2, 8, 0),
      end: DateTime(2025, 9, 2, 10, 0),
      uniAppointmentSubject: "Mathematics - Algebra",
      uniappointmentLocation: "Room A101",
      type: UniAppointmentTypes.course,
      recurrence: "FREQ=WEEKLY;BYDAY=TU",
    ),
    UniAppointment(
      start: DateTime(2025, 9, 4, 10, 0),
      end: DateTime(2025, 9, 4, 12, 0),
      uniAppointmentSubject: "Operating Systems",
      uniappointmentLocation: "Room C203",
      type: UniAppointmentTypes.course,
      recurrence: "FREQ=WEEKLY;BYDAY=TH",
    ),
    UniAppointment(
      start: DateTime(2025, 9, 6, 14, 0),
      end: DateTime(2025, 9, 6, 16, 0),
      uniAppointmentSubject: "Software Engineering",
      uniappointmentLocation: "Room B305",
      type: UniAppointmentTypes.course,
      recurrence: "FREQ=WEEKLY;BYDAY=SA",
    ),
    UniAppointment(
      start: DateTime(2025, 9, 6, 14, 0),
      end: DateTime(2025, 9, 6, 16, 0),
      uniAppointmentSubject: "Software Engineering",
      uniappointmentLocation: "Room B305",
      type: UniAppointmentTypes.course,
      recurrence: "FREQ=WEEKLY;BYDAY=WE,TH",
    ),
    UniAppointment(
      start: DateTime(2025, 9, 6, 14, 0),
      end: DateTime(2025, 9, 6, 16, 0),
      uniAppointmentSubject: "Artificial Intelligence",
      uniappointmentLocation: "Room B305",
      type: UniAppointmentTypes.course,
      recurrence: "FREQ=WEEKLY;BYDAY=WE,TH",
    ),

    // // --- TD ---
    // UniAppointment(
    //   start: DateTime(2025, 9, 3, 9, 0),
    //   end: DateTime(2025, 9, 3, 11, 0),
    //   uniAppointmentSubject: "TD - Data Structures",
    //   uniappointmentLocation: "Room D110",
    //   type: UniAppointmentTypes.td,
    //   recurrence: "FREQ=WEEKLY;BYDAY=WE",
    // ),
    // UniAppointment(
    //   start: DateTime(2025, 9, 5, 8, 30),
    //   end: DateTime(2025, 9, 5, 10, 30),
    //   uniAppointmentSubject: "TD - Probability",
    //   uniappointmentLocation: "Room A201",
    //   type: UniAppointmentTypes.td,
    //   recurrence: "FREQ=WEEKLY;BYDAY=FR",
    // ),
    // UniAppointment(
    //   start: DateTime(2025, 9, 1, 13, 0),
    //   end: DateTime(2025, 9, 1, 15, 0),
    //   uniAppointmentSubject: "TD - Databases",
    //   uniappointmentLocation: "Room C104",
    //   type: UniAppointmentTypes.td,
    //   recurrence: "FREQ=WEEKLY;BYDAY=MO",
    // ),

    // // --- TP ---
    // UniAppointment(
    //   start: DateTime(2025, 9, 2, 14, 0),
    //   end: DateTime(2025, 9, 2, 16, 0),
    //   uniAppointmentSubject: "TP - Networks",
    //   uniappointmentLocation: "Lab N2",
    //   type: UniAppointmentTypes.tp,
    //   recurrence: "FREQ=WEEKLY;BYDAY=TU",
    // ),
    // UniAppointment(
    //   start: DateTime(2025, 9, 4, 8, 0),
    //   end: DateTime(2025, 9, 4, 10, 0),
    //   uniAppointmentSubject: "TP - Web Development",
    //   uniappointmentLocation: "Lab W1",
    //   type: UniAppointmentTypes.tp,
    //   recurrence: "FREQ=WEEKLY;BYDAY=TH",
    // ),
    // UniAppointment(
    //   start: DateTime(2025, 9, 6, 16, 0),
    //   end: DateTime(2025, 9, 6, 18, 0),
    //   uniAppointmentSubject: "TP - AI Introduction",
    //   uniappointmentLocation: "Lab AI",
    //   type: UniAppointmentTypes.tp,
    //   recurrence: "FREQ=WEEKLY;BYDAY=SA",
    // ),

    // // --- Évènement spécial ---
    // UniAppointment(
    //   start: DateTime(2025, 9, 10, 9, 0),
    //   end: DateTime(2025, 9, 10, 12, 0),
    //   uniAppointmentSubject: "Conference: Future of Computing",
    //   uniappointmentLocation: "Auditorium 1",
    //   type: UniAppointmentTypes.specialEvent,
    //   recurrence: "FREQ=WEEKLY;BYDAY=WE,SU;BYMONTHDAY=10",
    // ),
    // UniAppointment(
    //   start: DateTime(2025, 10, 15, 14, 0),
    //   end: DateTime(2025, 10, 15, 17, 0),
    //   uniAppointmentSubject: "Hackathon Preparation",
    //   uniappointmentLocation: "Innovation Hub",
    //   type: UniAppointmentTypes.specialEvent,
    //   recurrence: "FREQ=WEEKLY;BYDAY=WE;INTERVAL=1",
    // ),
    // UniAppointment(
    //   start: DateTime(2025, 12, 20, 8, 0),
    //   end: DateTime(2025, 12, 20, 18, 0),
    //   uniAppointmentSubject: "End of Semester Party",
    //   uniappointmentLocation: "Main Hall",
    //   type: UniAppointmentTypes.specialEvent,
    //   recurrence: "FREQ=WEEKLY;BYDAY=SU,TH,MO;BYMONTHDAY=20",
    // ),
  ];
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

  Future<UniAppointment> createAppointment({
    required DateTime start,
    required DateTime end,
    required String uniAppointmentSubject,
    required String location,
    required UniAppointmentTypes type,
    required String recurrence,
  }) async {
    final newAppointment = UniAppointment(
      start: start,
      end: end,
      uniAppointmentSubject: uniAppointmentSubject,
      uniappointmentLocation: location,
      type: type,
      recurrence: recurrence,
    );
    _appointments.add(newAppointment);
    return newAppointment;
  }

  Stream<List<UniAppointment>> get allAppointments =>
      _appointmentStreamController.stream.map((appointment) => appointment);
}
