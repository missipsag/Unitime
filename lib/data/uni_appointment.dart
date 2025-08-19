import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unitime/core/constants/uni_appointment_types.dart';
import 'package:unitime/core/constants/colors.dart';

class UniAppointment extends Appointment {
  final DateTime start;
  final DateTime end;
  final String uniAppointmentSubject;
  final int roomNum;
  final UniAppointmentTypes type;

  UniAppointment({
    required this.start,
    required this.end,
    required this.uniAppointmentSubject,
    required this.roomNum,
    required this.type,
  }) : super(
         startTime: start,
         endTime: end,
         subject: uniAppointmentSubject,
         color: appointementColor[type] as Color,
       );
}

class UniAppointmentService {

  final List<UniAppointment> _uniAppointments = [];
  late final StreamController<List<UniAppointment>> _uniAppointmentsStreamConroller;

  static final UniAppointmentService _shared = UniAppointmentService._sharedInstance();
  UniAppointmentService._sharedInstance(){
    _uniAppointmentsStreamConroller = StreamController<List<UniAppointment>>.broadcast(
      onListen: () {
      _uniAppointmentsStreamConroller.sink.add(_uniAppointments);
    });
  }
  factory UniAppointmentService() => _shared; 


  void addUniAppointment({
    required DateTime start,
    required DateTime end,
    required String uniAppointmentSubject,
    required int roomNum,
    required UniAppointmentTypes type,
  }) {
    final UniAppointment appointement = UniAppointment(
      start: start,
      end: end,
      uniAppointmentSubject: uniAppointmentSubject,
      roomNum: roomNum,
      type: type,
    );
    _uniAppointments.add(appointement);
  }

  List<UniAppointment> getUniAppointments() {


    final DateTime today = DateTime.now();
      final DateTime startTime = DateTime(
        today.year,
        today.month,
        today.day,
        9,
        0,
        0,
      );
      final DateTime endTime = startTime.add(Duration(hours: 2));
      final DateTime startTime2 = DateTime(
        today.year,
        today.month,
        today.day,
        11,
        30,
        0,
      );
      final DateTime endTime2 = startTime2.add(Duration(hours: 2));
      _uniAppointments.add(
        UniAppointment(
          start: startTime2,
          end: endTime2,
          uniAppointmentSubject: 'Cours IA',
          roomNum: 4,
          type: UniAppointmentTypes.course
        ),
      );
       _uniAppointments.add(
      UniAppointment(
        start: startTime,
        end: endTime,
        uniAppointmentSubject: 'Cours SM',
        roomNum: 4,
        type: UniAppointmentTypes.td,
      ),
    );

      final DateTime startTime3 = DateTime(
        today.year,
        today.month,
        today.day,
        12,
        0,
        0,
      );
      final DateTime endTime3 = startTime3.add(Duration(hours: 2));
       _uniAppointments.add(
      UniAppointment(
        start: startTime3,
        end: endTime3,
        uniAppointmentSubject: 'TP ALGO',
        roomNum: 4,
        type: UniAppointmentTypes.tp,
      ),
    );

    return _uniAppointments;
  }

}
