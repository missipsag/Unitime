import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unitime/core/constants/colors.dart';
import 'package:unitime/data/uni_appointment.dart';

Widget appointmentBuilder(
  BuildContext context,
  CalendarAppointmentDetails details,
  CalendarController controller,
) {
  CalendarController controller0 = controller;
  UniAppointment appointment = details.appointments.first;
  final String location = appointment.appointmentLocation;
  var timeFormat;
  return Container(
    padding: const EdgeInsets.only(left: 4),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(6),
        bottomRight: Radius.circular(6),
      ),
      color: appointementColor[appointment.uniAppointmentType]!.withAlpha(30),
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
              "${timeFormat.format(appointment.start)} - ${timeFormat.format(appointment.end)}",
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
              "${timeFormat.format(appointment.start)} - ${timeFormat.format(appointment.end)}",
              style: const TextStyle(overflow: TextOverflow.fade),
              softWrap: false,
            ),
          ),
        ],
      ],
    ),
  );
}
