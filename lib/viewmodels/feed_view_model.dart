import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unitime/core/constants/app_routes.dart';
import 'package:unitime/core/constants/uni_appointment_scope.dart';
import 'package:unitime/core/constants/uni_appointment_type.dart';
import 'package:unitime/core/utils/command.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/uni_appointment.dart';
import 'package:unitime/repository/uni_appointment_repository.dart';

class FeedViewModel extends ChangeNotifier {
  FeedViewModel({required UniAppointmentRepository uniAppointmentRepository})
    : _uniAppointmentRepository = uniAppointmentRepository {
    loadCurrAppointments = Command(_loadCurrppointment)..execute();
    loadUpcomingSpecialEvents = Command(_loadUpcomingSpecialEvents)..execute();
  }

  final UniAppointmentRepository _uniAppointmentRepository;

  List<UniAppointment> _currAppointments = [];
  List<UniAppointment> get currAppointments => _currAppointments;

  List<UniAppointment> _upcomingSpecialEvents = [];
  List<UniAppointment> get upcomingSpecialEvents => _upcomingSpecialEvents;

  late final Command loadCurrAppointments;
  late final Command loadUpcomingSpecialEvents;

  Future<Result> _loadCurrppointment() async {
    final List<UniAppointment> mockApps = [
      UniAppointment(
        id: 3,
        start: DateTime.now().subtract(Duration(minutes: 30)),
        end: DateTime.now().add(Duration(hours: 1)),
        title: "Sturcture MAchine",
        appointmentLocation: "Salle 9",
        uniAppointmentType: UniAppointmentType.COURSE,
        uniAppointmentScope: UniAppointmentScope.GROUP,
        recurrence: "FREQ=WEEKLY,BYDAY=MON,TUE,SAT",
      ),
      UniAppointment(
        id: 3,
        start: DateTime.now().subtract(Duration(minutes: 30)),
        end: DateTime.now().add(Duration(hours: 1)),
        title: "Aritificial Intelligence",
        appointmentLocation: "Salle 9",
        uniAppointmentType: UniAppointmentType.TD,
        uniAppointmentScope: UniAppointmentScope.GROUP,
        recurrence: "FREQ=WEEKLY,BYDAY=MON,TUE,SAT",
      ),
      UniAppointment(
        id: 3,
        start: DateTime.now().subtract(Duration(minutes: 30)),
        end: DateTime.now().add(Duration(hours: 1)),
        title: "Algorithms and Data Structures",
        appointmentLocation: "Salle 9",
        uniAppointmentType: UniAppointmentType.TP,
        uniAppointmentScope: UniAppointmentScope.GROUP,
        recurrence: "FREQ=WEEKLY,BYDAY=MON,TUE,SAT",
      ),
    ];
    try {
      final res = await Isolate.run<Result<List<UniAppointment>>>(
        () async =>
            await _uniAppointmentRepository.getCurrentAppointments(TAppRoutes.token),
      );
      
      switch (res) {
        case Ok<List<UniAppointment>>():
          _currAppointments = res.value;
          break;

        case Error<List<UniAppointment>>():
          break;
      }
      // _currAppointments = mockApps;
      return res;
    } finally {
      notifyListeners();
    }
  }

  Future<Result> _loadUpcomingSpecialEvents() async {
    final mockSpecialEvent = <UniAppointment>[
      UniAppointment(
        id: 3,
        start: DateTime.now().subtract(Duration(minutes: 30)),
        end: DateTime.now().add(Duration(hours: 1)),
        title: "Sturcture MAchine",
        appointmentLocation: "Salle 9",
        uniAppointmentType: UniAppointmentType.SPECIAL_EVENT,
        uniAppointmentScope: UniAppointmentScope.GROUP,
        recurrence: "FREQ=WEEKLY,BYDAY=MON,TUE,SAT",
      ),
      UniAppointment(
        id: 3,
        start: DateTime.now().subtract(Duration(minutes: 30)),
        end: DateTime.now().add(Duration(hours: 1)),
        title: "Aritificial Intelligence",
        appointmentLocation: "Salle 9",
        uniAppointmentType: UniAppointmentType.SPECIAL_EVENT,
        uniAppointmentScope: UniAppointmentScope.PROMOTION,
        recurrence: "FREQ=WEEKLY,BYDAY=MON,TUE,SAT",
      ),
      UniAppointment(
        id: 3,
        start: DateTime.now().subtract(Duration(minutes: 30)),
        end: DateTime.now().add(Duration(hours: 1)),
        title: "Algorithms and Data Structures",
        appointmentLocation: "Salle 9",
        uniAppointmentType: UniAppointmentType.SPECIAL_EVENT,
        uniAppointmentScope: UniAppointmentScope.GLOBAL,
        recurrence: "FREQ=WEEKLY,BYDAY=MON,TUE,SAT",
      ),
    ];
    try {
      final res = await Isolate.run<Result<List<UniAppointment>>>(
        () async =>
            await _uniAppointmentRepository.getUpcomingSpecialEvents(TAppRoutes.token),
      );
      //final res = await _uniAppointmentRepository.getUpcomingSpecialEvents();
      switch (res) {
        case Ok<List<UniAppointment>>():
          _upcomingSpecialEvents = res.value;
          break;
        case Error<List<UniAppointment>>():
          break;
      }
      _upcomingSpecialEvents = mockSpecialEvent;
      return res;
    } finally {
      notifyListeners();
    }
  }
}
