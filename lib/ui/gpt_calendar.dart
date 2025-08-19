import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarSwitcherDemo extends StatefulWidget {
  const CalendarSwitcherDemo({super.key});

  @override
  State<CalendarSwitcherDemo> createState() => _CalendarSwitcherDemoState();
}

class _CalendarSwitcherDemoState extends State<CalendarSwitcherDemo> {
  final CalendarController _controller = CalendarController();

  // Use a single source of truth for the icon shown on the button.
  static const Map<CalendarView, IconData> viewToIcon = {
    CalendarView.month: Icons.grid_on_outlined,
    CalendarView.week: Icons.view_week,
    CalendarView.day: Icons.view_day,
    CalendarView.schedule: Icons.view_agenda,
  };

  @override
  void initState() {
    super.initState();
    _controller.view = CalendarView.day; // initial mode
  }

  @override
  Widget build(BuildContext context) {
    final currentIcon = viewToIcon[_controller.view ?? CalendarView.day]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SfCalendar Switcher'),
        actions: [
          PopupMenuButton<CalendarView>(
            icon: Icon(currentIcon),
            onSelected: (view) {
              // This line actually switches the calendar view.
              _controller.view = view;
              // setState only updates the AppBar icon; the calendar reacts via controller.
              setState(() {});
            },
            itemBuilder: (context) => viewToIcon.entries.map((e) {
              return PopupMenuItem<CalendarView>(
                value: e.key,
                child: Row(
                  children: [
                    Icon(e.value),
                    const SizedBox(width: 8),
                    Text(e.key.toString().split('.').last),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: SfCalendar(
        controller: _controller,
        // Don’t also pass `view:` when using a controller.
        allowedViews: const [
          CalendarView.day,
          CalendarView.week,
          CalendarView.month,
          CalendarView.schedule,
        ],
        showTodayButton: true,
        showNavigationArrow: true,
      ),
    );
  }
}
