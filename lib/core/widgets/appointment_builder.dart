import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unitime/data/uni_appointment.dart';

Widget _appointmentBuilder(
  BuildContext context,
  CalendarAppointmentDetails details,
  CalendarController controller
) {
  CalendarController controller0 = controller;
  UniAppointment appointment = details.appointments.first;
  final String location = appointment.location!;
  var timeFormat;
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
          if (controller0.view == CalendarView.month &&
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
          if (controller0.view == CalendarView.day ||
              controller0.view == CalendarView.workWeek ||
              controller0.view == CalendarView.schedule) ...[
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
