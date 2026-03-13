import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/core/constants/colors.dart';
import 'package:unitime/core/widgets/appointment_type_indicator_widget.dart';
import 'package:unitime/data/uni_appointment.dart';

class EventListTileWidget extends StatelessWidget {
  const EventListTileWidget({
    super.key,
    required this.height,
    required this.width,
    required this.app,
  });
  final UniAppointment app;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final double containerHeight = height * 0.17;
    final double contaierWidth = width * 0.8;
    return Container(
      width: contaierWidth,
      height: containerHeight,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(top: 12, right: 16, left: 16, bottom: 10),
      decoration: BoxDecoration(
        color: appointementColor[app.uniAppointmentType],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 128, 128, 128).withAlpha(1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppointmentTypeIndicatorWidget(
                  height: containerHeight * 0.4,
                  width: width * 0.15,
                  type: app.uniAppointmentType,
                ),
                SizedBox(width: TAppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        app.title,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: TAppSpacing.xs),
                      Row(
                        children: [
                          Text(
                            "from :",
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(color: Colors.white),
                          ),
                          SizedBox(width: TAppSpacing.xs),
                          Text(
                            '${DateFormat('MMMM d').format(app.start)} at ${DateFormat.Hm().format(app.end).toString()}',
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "to :",
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(color: Colors.white),
                          ),
                          SizedBox(width: TAppSpacing.xs),
                          Text(
                            '${DateFormat('MMMM d').format(app.end)} at ${DateFormat.Hm().format(app.end).toString()}',
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 1),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white),
                          SizedBox(width: TAppSpacing.xs),
                          Text(
                            app.location ?? "N/A",
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
