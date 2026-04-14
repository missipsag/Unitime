import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/core/constants/colors.dart';
import 'package:unitime/core/constants/uni_appointment_type.dart';
import 'package:unitime/core/constants/user_role.dart';
import 'package:unitime/core/dialogs/add_uni_appointment_dialog.dart';
import 'package:unitime/data/uni_appointment.dart';
import 'package:unitime/data/uni_appointment_data_source.dart';
import 'package:unitime/data/user.dart';
import 'package:unitime/providers/session_provider.dart';
import 'package:unitime/repository/uni_appointment_repository.dart';
import 'package:unitime/viewmodels/add_uni_appointment_view_model.dart';
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
  final List<CalendarView> _options = [
    CalendarView.day,
    CalendarView.week,
    CalendarView.month,
  ];

  late final ValueNotifier<int> _viewIndex;
  late final ValueNotifier<DateTime> _currDate;

  @override
  void initState() {
    super.initState();
    widget.viewModel.loadAppointments.execute();
    widget.viewModel.loadAppointments.addListener(_handleAppointmentFetchError);
    _viewIndex = ValueNotifier<int>(1);
    _currDate = ValueNotifier<DateTime>(DateTime.now());
  }

  @override
  void dispose() {
    widget.viewModel.loadAppointments.removeListener(
      _handleAppointmentFetchError,
    );
    _viewIndex.dispose();
    _currDate.dispose();
    super.dispose();
  }

  void _handleAppointmentFetchError() {
    if (widget.viewModel.loadAppointments.completed) {
      ThemeData theme = Theme.of(context);
      if (widget.viewModel.loadAppointments.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "An error occurred when fetching appointments. Please try again later.",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onError,
              ),
            ),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        widget.viewModel.loadAppointments.clear();
      }
    }
  }

  Future<DateTime?> _openCustomDatePicker() async {
    // TODO : Run this on a differenct  Isolate  to offload the main thread
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.viewModel.controller.displayDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),

      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );
    return pickedDate;
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = context.read<SessionProvider>().currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        titleSpacing: 0,
        title: TextButton.icon(
          onPressed: () async {
            final pickedDate = await _openCustomDatePicker();
            if (pickedDate != null) {
              widget.viewModel.controller.displayDate = pickedDate;
              widget.viewModel.controller.selectedDate = pickedDate;
              _currDate.value = pickedDate;
            }
          },
          label: ValueListenableBuilder(
            valueListenable: _currDate,
            builder: (context, value, child) {
              return Text(
                "${CalendarViewModel.monthDayRangeFormat.format(value)} ",

                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              );
            },
          ),
          iconAlignment: IconAlignment.end,
          icon: RotatedBox(quarterTurns: 1, child: Icon(Icons.chevron_right)),
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  widget.viewModel.controller.displayDate = DateTime.now();
                },
                tooltip: "Today",
                icon: Icon(Icons.today_rounded),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ValueListenableBuilder(
                  valueListenable: _viewIndex,
                  builder: (context, value, child) {
                    ThemeData theme = Theme.of(context);
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: List.generate(_options.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            _viewIndex.value = index;
                            widget.viewModel.controller.view = _options[index];
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _viewIndex.value == index
                                  ? theme.colorScheme.secondaryContainer
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _viewIndex.value == index
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(13),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Text(
                              _options[index].name,
                              style: TextStyle(
                                color: _viewIndex.value == index
                                    ? theme
                                          .colorScheme
                                          .onSecondary // Dark blue text
                                    : Colors.grey, // Greyish text
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton:
          // only a standard user can't create appointments.
          (currentUser.roles.contains(UserRole.GROUP_ADMIN) ||
              currentUser.roles.contains(UserRole.PROMOTION_ADMIN) ||
              currentUser.roles.contains(UserRole.SUPER_ADMIN))
          ? IconButton(
              color: Theme.of(context).colorScheme.onPrimary,
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),

              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AddUniAppointmentDialog(
                        viewModel: AddUniAppointmentViewModel(
                          appointmentRepository: UniAppointmentRepository(),
                        ),
                      );
                    },
                  ),
                );
              },
              icon: Icon(Icons.add),
            )
          : const SizedBox.shrink(),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.viewModel.loadAppointments,
          builder: (context, _) {
            if (widget.viewModel.loadAppointments.running) {
              return AlertDialog.adaptive(
                insetPadding: EdgeInsets.symmetric(horizontal: 16),
                contentPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                elevation: 5,
                content: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(overscroll: false),
              child: SfCalendar(
                controller: widget.viewModel.controller,
                view: widget.viewModel.controller.view!,

                headerDateFormat: "EEE",
                initialDisplayDate:
                    widget.viewModel.controller.displayDate ?? DateTime.now(),
                initialSelectedDate:
                    widget.viewModel.controller.selectedDate ?? DateTime.now(),
                backgroundColor: Theme.of(context).colorScheme.surface,

                onViewChanged: (details) {
                  widget.viewModel.visibleDates = details.visibleDates;
                  widget.viewModel.updateIcon();
                  widget.viewModel.changeTitleDisplayDate(details);
                },

                dataSource: UniAppointmentDataSource(
                  widget.viewModel.appointments,
                ),

                timeSlotViewSettings: const TimeSlotViewSettings(
                  startHour: 6,
                  endHour: 23,
                  timeIntervalHeight: 100,
                  timeFormat: "HH:mm",
                ),

                selectionDecoration: BoxDecoration(),

                appointmentBuilder: (context, CalendarAppointmentDetails details) {
                  final UniAppointment appointment = details.appointments.first;
                  final String location = appointment.appointmentLocation;
                  final UniAppointmentType appointmentType =
                      appointment.uniAppointmentType;
                  final DateFormat timeFormat = CalendarViewModel.timeFormat;
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        barrierColor: Colors.grey.withAlpha(3),
                        useSafeArea: true,
                        context: context,
                        builder: (context) {
                          ThemeData theme = Theme.of(context);
                          return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: AlertDialog(
                              insetPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              contentPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              elevation: 5,
                              content: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 10,
                                ),

                                margin: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color:
                                          appointementColor[appointmentType]!,
                                      width: 8,
                                    ),
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  color: widget.viewModel
                                      .appointmentBackgroundWidgetColor(
                                        appointmentType,
                                      ),

                                  boxShadow: [BoxShadow(color: Colors.black)],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appointment.title,

                                      style: theme.textTheme.headlineMedium!
                                          .copyWith(
                                            color:
                                                appointementColor[appointmentType],
                                          ),
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                    ),
                                    const SizedBox(height: TAppSpacing.lg),

                                    Row(
                                      children: [
                                        Text(
                                          " Location : ",
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    appointementColor[appointmentType],
                                              ),
                                        ),
                                        Text(
                                          appointment.appointmentLocation,
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    appointementColor[appointmentType],
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: TAppSpacing.lg),
                                    Row(
                                      children: [
                                        Text(
                                          " starts at : ",
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    appointementColor[appointmentType],
                                              ),
                                        ),
                                        Text(
                                          timeFormat.format(appointment.start),
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    appointementColor[appointmentType],
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: TAppSpacing.lg),
                                    Row(
                                      children: [
                                        Text(
                                          " ends at : ",
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    appointementColor[appointmentType],
                                              ),
                                        ),
                                        Text(
                                          timeFormat.format(appointment.end),
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    appointementColor[appointmentType],
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: appointementColor[appointmentType]!,
                            width: 5,
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        color: widget.viewModel
                            .appointmentBackgroundWidgetColor(appointmentType),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          SizedBox(
                            width: details.bounds.width,
                            child: Text(
                              appointment.title,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color:
                                        appointementColor[appointment
                                            .uniAppointmentType],
                                    overflow: TextOverflow.fade,
                                    fontWeight: FontWeight.w600,
                                  ),
                              softWrap: true,
                              maxLines: 3,
                            ),
                          ),
                          if (widget.viewModel.controller.view ==
                                  CalendarView.month &&
                              details.bounds.height > 50) ...[
                            SizedBox(
                              width: details.bounds.width,

                              child: Text(
                                location,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color:
                                          appointementColor[appointment
                                              .uniAppointmentType],
                                      overflow: TextOverflow.fade,
                                      fontWeight: FontWeight.w400,
                                    ),
                                softWrap: true,
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(
                              width: details.bounds.width,

                              child: Text(
                                "${timeFormat.format(appointment.start)} - ${timeFormat.format(appointment.end)}",
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(
                                      color:
                                          appointementColor[appointment
                                              .uniAppointmentType],
                                      fontWeight: FontWeight.w400,
                                    ),
                                softWrap: true,
                              ),
                            ),
                          ],
                          if (widget.viewModel.controller.view ==
                                  CalendarView.day ||
                              widget.viewModel.controller.view ==
                                  CalendarView.workWeek ||
                              widget.viewModel.controller.view ==
                                  CalendarView.schedule) ...[
                            SizedBox(
                              width: details.bounds.width,

                              child: Text(
                                location,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color:
                                          appointementColor[appointment
                                              .uniAppointmentType],
                                      overflow: TextOverflow.fade,
                                      fontWeight: FontWeight.w600,
                                    ),
                                maxLines: 2,
                                softWrap: true,
                              ),
                            ),
                            SizedBox(
                              width: details.bounds.width,

                              child: Text(
                                "${timeFormat.format(appointment.start)} - ${timeFormat.format(appointment.end)}",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color:
                                          appointementColor[appointment
                                              .uniAppointmentType],
                                      overflow: TextOverflow.fade,
                                      fontWeight: FontWeight.w600,
                                    ),
                                softWrap: true,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
                allowedViews: _options,
                showCurrentTimeIndicator: true,
                showNavigationArrow: false,

                monthViewSettings: MonthViewSettings(
                  showTrailingAndLeadingDates: false,
                  showAgenda: true,
                ),
                headerHeight: 0,
              ),
            );
          },
        ),
      ),
    );
  }
}
