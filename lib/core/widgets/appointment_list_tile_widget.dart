import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/core/constants/colors.dart';
import 'package:unitime/core/widgets/appointment_type_indicator_widget.dart';
import 'package:unitime/core/widgets/progress_bar_widget.dart';
import 'package:unitime/data/uni_appointment.dart';

class AppointmentListTileWidget extends StatelessWidget {
  const AppointmentListTileWidget({
    super.key,
    required this.height,
    required this.width,
    required this.app,
  });
  final double height;
  final double width;
  final UniAppointment app;

  @override
  Widget build(BuildContext context) {
    final int timePassedSeconds = DateTime.now()
        .difference(app.start)
        .inSeconds;
    final int durationSeconds = app.end.difference(app.start).inSeconds;
    final double progress = (timePassedSeconds * 100) / durationSeconds;

    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppointmentTypeIndicatorWidget(
                height: height * 0.35,
                width: width * 0.18,
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
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: TAppSpacing.xs),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white),
                        SizedBox(width: TAppSpacing.xs),
                        Text(
                          '${DateFormat.Hm().format(app.start)} - ${DateFormat.Hm().format(app.end).toString()}',
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.white),
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
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: TAppSpacing.sm),
          ProgressBarWidget(height: height, width: width, progress: progress),
        ],
      ),
    );
  }
}



// Column(
//         children: [
//           Row(
//             children: [
//               AppointmentTypeIndicatorWidget(
//                 height: height * 0.2,
//                 width: width * 0.2,
//                 type: app.uniAppointmentType,
//               ),
//               SizedBox(
//                 height: height,
//                 width: width * 0.8,
//                 child: Column(
                  
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       app.title,
//                       softWrap: false,
//                       overflow: TextOverflow.fade,
//                       style: Theme.of(
//                         context,
//                       ).textTheme.headlineMedium!.copyWith(color: Colors.white),
//                     ),
//                     const SizedBox(height: TAppSpacing.xs),
//                     Row(
//                       children: [
//                         Icon(Icons.access_time, color: Colors.white),
//                         SizedBox(width: TAppSpacing.xs),
//                         Text(
//                           '${DateFormat.Hm().format(app.start)} - ${DateFormat.Hm().format(app.end).toString()}',
//                           softWrap: false,
//                           overflow: TextOverflow.fade,
//                           style: Theme.of(
//                             context,
//                           ).textTheme.bodySmall!.copyWith(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 1),
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, color: Colors.white),
//                         SizedBox(width: TAppSpacing.xs),
//                         Text(
//                           app.location ?? "N/A",
//                           style: Theme.of(
//                             context,
//                           ).textTheme.bodySmall!.copyWith(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: TAppSpacing.sm),
//           ProgressBarWidget(height: height, width: width, progress: 49),
//         ],
//       ),