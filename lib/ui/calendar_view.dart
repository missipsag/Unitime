import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unitime/core/dialogs/add_uni_appointment_dialog.dart';
import 'package:unitime/data/uni_appointment.dart';
import 'package:unitime/data/uni_appointment_data_source.dart';
import 'package:unitime/service/appointment_service.dart';

// TODOS :
//* make the app bar date change according to visible display dates and views
//* customize the agenda in month view (I think it is better to show agenda rather than changing into day view when the
//* clicks in a month cell)
//* when the user adds a new appointment There is a problematic case :
//* when he chooses the recurrence "weekly" he doesn't need to specify the date only the hours and minutes
//* now we implemented that in the front end but in the backend not yet. It just happens
//* that the recurrence overrides the date.

class Calendar extends StatefulWidget {
  const Calendar({super.key});
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  static const IconData monthIcon = Icons.grid_on_outlined;
  static const IconData weekIcon = Icons.view_week;
  static const IconData dayIcon = Icons.view_day;
  static const IconData scheduleIcon = Icons.view_agenda;
  static const IconData todayIcon = Icons.today;
  IconData _selectedIcon = Icons.view_day;

  static final DateFormat _timeFormat = DateFormat('hh:mm a');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');
  static final DateFormat _monthDayRangeFormat = DateFormat('MMM d');
  static final DateFormat _dayFormat = DateFormat('MMMM d, yyyy');
  static final DateTime _today = DateTime.now();

  late final CalendarController _controller;

  late final AppointmentService _appointmentService;
  late UniAppointmentDataSource _myDataSource;
  late String _titleDate;
  List<DateTime> _visibleDates = <DateTime>[];

  CalendarView changeCalendarMode(IconData choice) {
    Map<IconData, CalendarView> iconToCalendarView = {
      monthIcon: CalendarView.month,
      dayIcon: CalendarView.day,
      weekIcon: CalendarView.workWeek,
      scheduleIcon: CalendarView.schedule,
    };
    return iconToCalendarView[choice]!;
  }

  List<UniAppointment> _appointments = [];

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

  Widget _appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    Appointment appointment = details.appointments.first;
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
                  "${_timeFormat.format(appointment.startTime)} - ${_timeFormat.format(appointment.endTime)}",
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
                  "${_timeFormat.format(appointment.startTime)} - ${_timeFormat.format(appointment.endTime)}",
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

  void _updateIcon() {
    _selectedIcon = viewToIcon[_controller.view] ?? Icons.view_day;
  }

  void _changeTitleDisplayDate(ViewChangedDetails details) {
    String nextTitle = "";

    final mid = details.visibleDates[details.visibleDates.length ~/ 2];
    if (_controller.view == CalendarView.month) {
      nextTitle = _monthYearFormat.format(mid);
    } else if (_controller.view == CalendarView.week ||
        _controller.view == CalendarView.workWeek) {
      nextTitle =
          "${_monthDayRangeFormat.format(details.visibleDates.first)}"
          " - ${_monthDayRangeFormat.format(details.visibleDates.last)}";
    } else if (_controller.view == CalendarView.day ||
        _controller.view == CalendarView.schedule) {
      nextTitle = _dayFormat.format(details.visibleDates.first);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_titleDate != nextTitle) {
        setState(() {
          _titleDate = nextTitle;
        });
      }
    });
  }

  Future<void> _fetchAppointments(DateTime start, DateTime end) async {
    Future.delayed(Duration(microseconds: 150));
  }

  Widget loadMoreWidget(
    BuildContext context,
    LoadMoreCallback loadMoreAppointments,
  ) {
    return FutureBuilder<void>(
      initialData: 'loading',
      future: loadMoreAppointments(),
      builder: (context, snapShot) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius:  BorderRadius.circular(15),
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor,
          ),
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _myDataSource = UniAppointmentDataSource(_appointments);
    _appointmentService = AppointmentService();
    _controller = CalendarController();
    _controller.view = CalendarView.day;
    _controller.displayDate = DateTime.now();
    _titleDate = DateFormat('MMMM d, yyyy').format(_controller.displayDate!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleDate),
        actions: [
          IconButton(
            onPressed: () {
              _controller.displayDate = DateTime.now();
               _changeTitleDisplayDate(ViewChangedDetails(_visibleDates));
            },
            icon: const Icon(todayIcon),
          ),
          PopupMenuButton(
            icon: Icon(_selectedIcon),
            onSelected: (CalendarView choice) {
              _controller.view = choice;
              // _updateIcon();
              // _changeTitleDisplayDate(ViewChangedDetails(_visibleDates));
              // setState(() {
              //   _selectedIcon;
              //   _titleDate;
              // });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: CalendarView.month,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:   [Icon(monthIcon), Text("   Month")],
                ),
              ),
              PopupMenuItem(
                value: CalendarView.workWeek,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Icon(weekIcon), Text("   Week")],
                ),
              ),
              PopupMenuItem(
                value: CalendarView.day,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Icon(dayIcon), Text("   Day")],
                ),
              ),
              PopupMenuItem(
                value: CalendarView.schedule,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Icon(scheduleIcon), Text("   Schedule")],
                ),
              ),
            ],
          ),
        ],
      ),

      body: StreamBuilder(
        stream: _appointmentService.allAppointments,
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.active:
              if (asyncSnapshot.hasData) {
                _appointments = asyncSnapshot.data as List<UniAppointment>;

                _myDataSource.appointments = _appointments;

                _myDataSource.notifyListeners(
                  //to avoid overflow in month cell
                  CalendarDataSourceAction.reset,
                  _appointments,
                );

                return SfCalendar(
                  controller: _controller,
                  headerDateFormat: "EEE",
                  initialDisplayDate: DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  allowViewNavigation: true,
                  viewNavigationMode: ViewNavigationMode.snap,
                  onViewChanged: (details) {
                    _visibleDates = details.visibleDates;
                    // debugPrint("##### Inside view changed");
                    // debugPrint('#####');
                    _updateIcon();
                    _changeTitleDisplayDate(details);
                  },
                  monthViewSettings: const MonthViewSettings(
                    dayFormat: "EEE",
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.indicator,

                    appointmentDisplayCount:3,
                    agendaViewHeight: 150,

                    // this is very important to display details in agenda
                    // this is possible by setting agendaItemHeight> 50
                    // 50 being the  threshold that I set for appointment builder
                    agendaItemHeight: 60,
                    showAgenda: false,
                  ),
                  dataSource: _myDataSource,
                  showNavigationArrow: false,
                  timeSlotViewSettings: const TimeSlotViewSettings(
                    startHour: 7,
                    endHour: 18,
                    nonWorkingDays: [DateTime.friday],
                    timeIntervalHeight: 40,
                  ),

                  showCurrentTimeIndicator: true,
                  headerHeight: 0,
                  appointmentBuilder: _appointmentBuilder,
                  scheduleViewSettings: const ScheduleViewSettings(
                    appointmentItemHeight: 60,
                  ),
                  monthCellBuilder: (BuildContext context, MonthCellDetails details) {
                    final appointments = details.appointments
                        .cast<Appointment>();
                    return RepaintBoundary(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Column(
                          children: [
                            // Date Number
                            Text(
                              details.date.day.toString(),

                              style: TextStyle(
                                color: Colors.white,

                                fontSize: 11,
                              ),
                            ),

                            ...appointments.take(3).map((
                              appointment,
                            ) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 1,
                                  horizontal: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: appointment.color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                width: double.infinity,
                                child: Text(
                                  softWrap: false,
                                  appointment.subject,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,

                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              );
                            }),

                            // More indicator if there are more appointments
                            // this for now is commented, because i happens that I got the
                            // exact behaviour that I wanted by combining monthcellBuilder and
                            // setting appointment.displayMode to indicator
                            // if (appointments.length > _maxAppointmentCount)
                            //   const Padding(
                            //     padding: EdgeInsets.only(top: 2.0),
                            //     child: Text(
                            //       '•••',
                            //       style: TextStyle(
                            //         color: Colors.white70,
                            //         fontSize: 12,
                            //       ),
                            //     ),
                            //   ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const LinearProgressIndicator();
              }

            default:
              return const LinearProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          /**
           TODOS:
           * add some spacing for the modal sheet on the top so that it doesn't go
           *  all the way to the top.
           * change the drag into an arrow
           * add a close button
           */

          final newAppointment = await showModalBottomSheet<UniAppointment>(
            context: context,
            showDragHandle: true,

            isScrollControlled: true,
            isDismissible: true,
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),

            builder: (BuildContext context) {
              return const SingleChildScrollView(
                child: AddUniAppointmentDialog(),
              );
            },
          );

          if (newAppointment != null) {
            setState(() {
              _appointments.add(newAppointment);
              _myDataSource.notifyListeners(CalendarDataSourceAction.add, [
                newAppointment,
              ]);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
