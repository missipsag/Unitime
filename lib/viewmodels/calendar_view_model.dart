import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unitime/data/uni_appointment.dart';
import 'package:unitime/repository/uni_appointment_repository.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarViewModel({
    required UniAppointmentRepository uniAppointmentRepository,
  }) : _uniAppointmentRepository = uniAppointmentRepository;

  final UniAppointmentRepository _uniAppointmentRepository;

  List<UniAppointment> _appointments = [];

  List<UniAppointment> get appointments => _appointments;

  static final DateFormat timeFormat = DateFormat('hh:mm a');
  static final DateFormat monthYearFormat = DateFormat('MMMM yyyy');
  static final DateFormat monthDayRangeFormat = DateFormat('MMM d');
  static final DateFormat dayFormat = DateFormat('MMMM d, yyyy');
  static final DateTime today = DateTime.now();

  static const IconData monthIcon = Icons.grid_on_outlined;
  static const IconData weekIcon = Icons.view_week;
  static const IconData dayIcon = Icons.view_day;
  static const IconData scheduleIcon = Icons.view_agenda;
  static const IconData todayIcon = Icons.today;
  IconData selectedIcon = Icons.view_day;

  final Map<CalendarView, IconData> viewToIcon = {
    CalendarView.month: Icons.grid_on_outlined,
    CalendarView.workWeek: Icons.view_week,
    CalendarView.day: Icons.view_day,
    CalendarView.schedule: Icons.view_agenda,
  };
  final Map<IconData, String> iconToLabel = {
    monthIcon: "Month",
    weekIcon: "Week",
    dayIcon: "Day",
    scheduleIcon: "Schedule",
  };

  CalendarView changeCalendarMode(IconData choice) {
    Map<IconData, CalendarView> iconToCalendarView = {
      monthIcon: CalendarView.month,
      dayIcon: CalendarView.day,
      weekIcon: CalendarView.workWeek,
      scheduleIcon: CalendarView.schedule,
    };
    return iconToCalendarView[choice]!;
  }

  final CalendarController _controller = CalendarController();

  CalendarController get controller => _controller;

  late String titleDate;
  List<DateTime> visibleDates = <DateTime>[];

  Widget _appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    UniAppointment appointment = details.appointments.first;
    final String location = appointment.location!;
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.only(left: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: appointment.color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SizedBox(
              width: details.bounds.width,

              child: Text(
                appointment.subject,
                textAlign: TextAlign.start,
                style: const TextStyle(overflow: TextOverflow.fade),
                softWrap: false,
              ),
            ),
            if (_controller.view == CalendarView.month &&
                details.bounds.height > 50) ...[
              SizedBox(
                width: details.bounds.width,

                child: Text(
                  location,
                  style: const TextStyle(overflow: TextOverflow.fade),
                  softWrap: false,
                ),
              ),
              SizedBox(
                width: details.bounds.width,

                child: Text(
                  "${timeFormat.format(appointment.startTime)} - ${timeFormat.format(appointment.endTime)}",
                  style: const TextStyle(overflow: TextOverflow.fade),
                  softWrap: false,
                ),
              ),
            ],
            if (_controller.view == CalendarView.day ||
                _controller.view == CalendarView.workWeek ||
                _controller.view == CalendarView.schedule) ...[
              SizedBox(
                width: details.bounds.width,

                child: Text(
                  location,
                  style: const TextStyle(overflow: TextOverflow.fade),
                  softWrap: false,
                ),
              ),
              SizedBox(
                width: details.bounds.width,

                child: Text(
                  "${timeFormat.format(appointment.startTime)} - ${timeFormat.format(appointment.endTime)}",
                  style: const TextStyle(overflow: TextOverflow.fade),
                  softWrap: false,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void changeTitleDisplayDate(ViewChangedDetails details) {
    String nextTitle = "";

    final mid = details.visibleDates[details.visibleDates.length ~/ 2];
    if (_controller.view == CalendarView.month) {
      nextTitle = monthYearFormat.format(mid);
    } else if (_controller.view == CalendarView.week ||
        _controller.view == CalendarView.workWeek) {
      nextTitle =
          "${monthDayRangeFormat.format(details.visibleDates.first)}"
          " - ${monthDayRangeFormat.format(details.visibleDates.last)}";
    } else if (_controller.view == CalendarView.day ||
        _controller.view == CalendarView.schedule) {
      nextTitle = dayFormat.format(details.visibleDates.first);
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!mounted) return;
    //   if (_titleDate != nextTitle) {
    //     setState(() {
    //       _titleDate = nextTitle;
    //     });
    //   }
    // });
  }

  void updateIcon() {
    selectedIcon = viewToIcon[_controller.view] ?? Icons.view_day;
  }

  Future<List<UniAppointment>> getAllAppointments() async {
    try {
      final appointments = await _uniAppointmentRepository.getAllAppointments();
      if (appointments is List<UniAppointment>) {
        _appointments = appointments;
      }

      return _appointments;
    } finally {
      notifyListeners();
    }
  }
}
