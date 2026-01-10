import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unitime/data/uni_appointment_data_source.dart';
import 'package:unitime/viewmodels/calendar_view_model.dart';

// TODOS :
//* make the app bar date change according to visible display dates and views
//* customize the agenda in month view (I think it is better to show agenda rather than changing into day view when the
//* clicks in a month cell)
//* when the user adds a new appointment There is a problematic case :
//* when he chooses the recurrence "weekly" he doesn't need to specify the date only the hours and minutes
//* now we implemented that in the front end but in the backend not yet. It just happens
//* that the recurrence overrides the date.

class MyCalendarView extends StatefulWidget {
  const MyCalendarView({super.key, required this.viewModel});

  final CalendarViewModel viewModel;

  @override
  State<MyCalendarView> createState() => _MyCalendarViewState();
}

class _MyCalendarViewState extends State<MyCalendarView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.viewModel.loadAppointments.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.viewModel.loadAppointments,
          builder: (context, _) {
            if (widget.viewModel.loadAppointments.running) {
              return const Center(child: CircularProgressIndicator());
            }
            return SfCalendar(
              controller: widget.viewModel.controller,
              view: CalendarView.month,
              headerDateFormat: "EEE",
              initialDisplayDate: DateTime.now(),
              initialSelectedDate: DateTime.now(),
              allowViewNavigation: true,
              viewNavigationMode: ViewNavigationMode.snap,
              onViewChanged: (details) {
                widget.viewModel.visibleDates = details.visibleDates;
                widget.viewModel.updateIcon();
                widget.viewModel.changeTitleDisplayDate(details);
              },
              monthViewSettings: const MonthViewSettings(
                dayFormat: "EEE",
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                appointmentDisplayCount: 3,
                agendaViewHeight: 150,

                // this is very important to display details in agenda
                // this is possible by setting agendaItemHeight> 50
                // 50 being the  threshold that I set for appointment builder
                agendaItemHeight: 60,
                showAgenda: false,
              ),
              dataSource: UniAppointmentDataSource(
                widget.viewModel.appointments,
              ),
              showNavigationArrow: false,
              timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 7,
                endHour: 20,
                // nonWorkingDays: [DateTime.friday],
                timeIntervalHeight: 40,
              ),

              showCurrentTimeIndicator: true,
              headerHeight: 0,
              //appointmentBuilder: _appointmentBuilder,
              scheduleViewSettings: const ScheduleViewSettings(
                appointmentItemHeight: 60,
              ),
              // monthCellBuilder:
              //     (BuildContext context, MonthCellDetails details) {
              //       final appointments = details.appointments
              //           .cast<Appointment>();
              //       return RepaintBoundary(
              //         child: Container(
              //           decoration: BoxDecoration(
              //             color: Colors.black87,
              //             border: Border.all(color: Colors.black),
              //           ),
              //           child: Column(
              //             children: [
              //               // Date Number
              //               Text(
              //                 details.date.day.toString(),

              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   fontSize: 11,
              //                 ),
              //               ),

              //               ...appointments.take(3).map((appointment) {
              //                 return Container(
              //                   margin: const EdgeInsets.symmetric(
              //                     vertical: 1,
              //                     horizontal: 2,
              //                   ),
              //                   padding: const EdgeInsets.symmetric(
              //                     vertical: 2,
              //                     horizontal: 4,
              //                   ),
              //                   decoration: BoxDecoration(
              //                     color: appointment.color,
              //                     borderRadius: BorderRadius.circular(4),
              //                   ),
              //                   width: double.infinity,
              //                   child: Text(
              //                     softWrap: false,
              //                     appointment.subject,
              //                     style: const TextStyle(
              //                       color: Colors.white,
              //                       fontSize: 10,

              //                       overflow: TextOverflow.fade,
              //                     ),
              //                   ),
              //                 );
              //               }),
              //             ],
              //           ),
              //         ),
              //       );
              //     },
            );
          },
        ),
      ),
    );
  }
}

// late String _titleDate;
// List<DateTime> _visibleDates = <DateTime>[];

// //        the app bar
// AppBar _appBar =    AppBar(
// title: Text(_titleDate),
// actions: [
// IconButton(
// onPressed: () {
// _controller.displayDate = DateTime.now();
// _changeTitleDisplayDate(ViewChangedDetails(_visibleDates));
// },
// icon: const Icon(todayIcon),
// ),
// PopupMenuButton(
// icon: Icon(_selectedIcon),
// onSelected: (CalendarView choice) {
// _controller.view = choice;
// },
// itemBuilder: (context) => const [
// PopupMenuItem(
// value: CalendarView.month,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [Icon(monthIcon), Text("   Month")],
// ),
// ),
// PopupMenuItem(
// value: CalendarView.workWeek,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [Icon(weekIcon), Text("   Week")],
// ),
// ),
// PopupMenuItem(
// value: CalendarView.day,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [Icon(dayIcon), Text("   Day")],
// ),
// ),
// PopupMenuItem(
// value: CalendarView.schedule,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [Icon(scheduleIcon), Text("   Schedule")],
// ),
// ),
// ],
// ),
// ],
// ),

//     the Calendar

//  the floating action button  FloatingActionButton(
//         onPressed: () async {
//           /**
//               TODOS:
//            * add some spacing for the modal sheet on the top so that it doesn't go
//            *  all the way to the top.
//            * change the drag into an arrow
//            * add a close button
//            */
//
//           final newAppointment = await showModalBottomSheet<UniAppointment>(
//             context: context,
//             showDragHandle: true,
//
//             isScrollControlled: true,
//             isDismissible: true,
//             useSafeArea: true,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//
//             builder: (BuildContext context) {
//               return const SingleChildScrollView(
//                 child: AddUniAppointmentDialog(),
//               );
//             },
//           );
//
//           if (newAppointment != null) {
//             setState(() {
//               _appointments.add(newAppointment);
//               _myDataSource.notifyListeners(CalendarDataSourceAction.add, [
//                 newAppointment,
//               ]);
//             });
//           }
//         },
//         child: const Icon(Icons.add),
//       ),
