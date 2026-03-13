import 'package:flutter/material.dart';
import 'package:unitime/core/constants/uni_appointment_scope.dart';
import 'package:unitime/core/constants/uni_appointment_type.dart';
import 'package:unitime/core/utils/command.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/uni_appointment.dart';

class UpdatesViewModel extends ChangeNotifier {
  UpdatesViewModel() {
    loadUpdates = Command(_loadUpdatedAppointments)..execute();
    clearUpdates = Command(_clearUpdates);
  }

  List<UniAppointment> _updtaedApps = [];
  List<UniAppointment> get updatedAppoitments => _updtaedApps;

  late final Command loadUpdates;
  late final Command clearUpdates;

  Future<Result> _loadUpdatedAppointments() async {
    final List<UniAppointment> mockUpdatedApps = [
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
      UniAppointment(
        id: 3,
        start: DateTime.now().subtract(Duration(minutes: 30)),
        end: DateTime.now().add(Duration(hours: 1)),
        title: "Entrepreneurship Workshop",
        appointmentLocation: "Salle 9",
        uniAppointmentType: UniAppointmentType.SPECIAL_EVENT,
        uniAppointmentScope: UniAppointmentScope.GROUP,
        recurrence: "FREQ=WEEKLY,BYDAY=MON,TUE,SAT",
      ),
      UniAppointment(
        id: 3,
        start: DateTime.now().subtract(Duration(minutes: 30)),
        end: DateTime.now().add(Duration(hours: 1)),
        title: "Huawei Hackathon",
        appointmentLocation: "Salle 9",
        uniAppointmentType: UniAppointmentType.SPECIAL_EVENT,
        uniAppointmentScope: UniAppointmentScope.GROUP,
        recurrence: "FREQ=WEEKLY,BYDAY=MON,TUE,SAT",
      ),
      UniAppointment(
        id: 3,
        start: DateTime.now().subtract(Duration(minutes: 30)),
        end: DateTime.now().add(Duration(hours: 1)),
        title: "Deep Learning and Neural Networks",
        appointmentLocation: "Salle 9",
        uniAppointmentType: UniAppointmentType.COURSE,
        uniAppointmentScope: UniAppointmentScope.GROUP,
        recurrence: "FREQ=WEEKLY,BYDAY=MON,TUE,SAT",
      ),
    ];
    try {
      await Future.delayed(Duration(seconds: 1));
      _updtaedApps = mockUpdatedApps;
      return Result.ok([]);
    } finally {
      notifyListeners();
    }
  }

  Future<Result> _clearUpdates() async {
    try {
      if (_updtaedApps.isNotEmpty) {
        _updtaedApps.clear();
      }
      return Result.ok([]);
    } finally {
      notifyListeners();
    }
  }
}
