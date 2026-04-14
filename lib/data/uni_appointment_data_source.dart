import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unitime/data/uni_appointment.dart';

class UniAppointmentDataSource extends CalendarDataSource {
  UniAppointmentDataSource(List<UniAppointment> source) {
    appointments = source;
  }

  UniAppointment _getAppointment(int index) {
    return appointments![index] as UniAppointment;
  }

  @override
  DateTime getStartTime(int index) => _getAppointment(index).start;

  @override
  DateTime getEndTime(int index) => _getAppointment(index).end;

  @override
  String getSubject(int index) => _getAppointment(index).title;

  @override
  bool isAllDay(int index) => false;

  UniAppointment getUniAppointment(int index) => _getAppointment(index);
}
