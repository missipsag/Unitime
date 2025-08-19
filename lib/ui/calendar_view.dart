import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unitime/core/dialogs/add_uni_appointment_dialog.dart';
import 'package:unitime/data/uni_appointment.dart';
import 'package:unitime/service/appointment_service.dart';

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
  CalendarView _calendarView = CalendarView.day;
  DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy");

  final CalendarController _controller = CalendarController();

  late final AppointmentService _appointmentService;
  late AppointementDataSource _myDataSource;

  CalendarView changeCalendarMode(IconData choice) {
    Map<IconData, CalendarView> iconToCalendarView = {
      monthIcon: CalendarView.month,
      dayIcon: CalendarView.day,
      weekIcon: CalendarView.week,
      scheduleIcon: CalendarView.schedule,
    };
    return iconToCalendarView[choice]!;
  }

  List<UniAppointment> _appointments = [];

  final Map<CalendarView, IconData> viewToIcon = {
    CalendarView.month: Icons.grid_on_outlined,
    CalendarView.week: Icons.view_week,
    CalendarView.day: Icons.view_day,
    CalendarView.schedule: Icons.view_agenda,
  };
  final Map<IconData, String> iconToLabel = {
    monthIcon: "Month",
    weekIcon: "Week",
    dayIcon: "Day",
    scheduleIcon: "Schedule",
  };

  @override
  void initState() {
    _myDataSource = AppointementDataSource(_appointments);
    _appointmentService = AppointmentService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedIcon = viewToIcon[_controller.view ?? CalendarView.day]!;
    return Scaffold(
      appBar: AppBar(
        title: Text(dateFormat.format(DateTime.now())),
        actions: [
          IconButton(
            onPressed: () {
              _controller.displayDate = DateTime.now();
            },
            icon: Icon(todayIcon),
          ),
          PopupMenuButton(
            icon: Icon(_selectedIcon),
            onSelected: (CalendarView choice) {
              _selectedIcon = viewToIcon[choice]!;
              _controller.view = choice;
              setState(() {});
            },
            itemBuilder: (BuildContext context) {
              return {monthIcon, weekIcon, dayIcon, scheduleIcon}.map((choice) {
                return PopupMenuItem<CalendarView>(
                  value: changeCalendarMode(choice),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Icon(choice), Text("   ${iconToLabel[choice]}")],
                  ),
                );
              }).toList();
            },
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
                return SfCalendar(
                  controller: _controller,
                  initialDisplayDate: DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  allowViewNavigation: true,
                  viewNavigationMode: ViewNavigationMode.snap,
                  // allowedViews: [
                  //   CalendarView.day,
                  //   CalendarView.week,
                  //   CalendarView.month,
                  //   CalendarView.schedule,
                  // ],
                  view: _calendarView,
                  monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
                  ),
                  dataSource: AppointementDataSource(_appointments),

                  showNavigationArrow: false,
                  timeSlotViewSettings: TimeSlotViewSettings(
                    startHour: 7,
                    endHour: 18,
                    nonWorkingDays: [6],
                  ),

                  showCurrentTimeIndicator: true,
                  headerHeight: 0,
                );
              } else {
                return LinearProgressIndicator();
              }

            default:
              return LinearProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return Center(
          //       child: AlertDialog(
          //         title: Text("Add appointment",textAlign: TextAlign.center,),
          //         content: Column(
          //           children: [
          //             TextFormField(autocorrect: false,decoration: InputDecoration(label: Text("Subject") ),),
          //             DropdownButtonFormField(items: DropdownMenuItem<<UniAppointmentTypes>> , onChanged: onChanged)
          //           ]),
          //       ),
          //     );
          //   },
          // );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddUniAppointmentDialog();
            },
          );
          setState(() {
            _myDataSource.notifyListeners(CalendarDataSourceAction.reset, [
              _appointments.last,
            ]);
          });
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Emploi'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Mises à jour',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class AppointementDataSource extends CalendarDataSource {
  AppointementDataSource(List<Appointment> source) {
    appointments = source;
  }
}
