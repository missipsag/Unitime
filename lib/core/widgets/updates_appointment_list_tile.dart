import 'package:flutter/material.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/core/constants/uni_appointment_type.dart';
import 'package:unitime/core/widgets/appointment_type_indicator_widget.dart';

class UpdatesAppointmentListTile extends StatelessWidget {
  const UpdatesAppointmentListTile({
    super.key,
    required this.height,
    required this.width,
    required this.type,
    required this.title,
    required this.since,
  });
  final double height;
  final double width;
  final UniAppointmentType type;
  final String title;
  final DateTime since;
  @override
  Widget build(BuildContext context) {
    final String typeName = type == UniAppointmentType.SPECIAL_EVENT
        ? 'special event'
        : type.name.toLowerCase();

    final String sinceString =
        since.isBefore(DateTime.now()..subtract(Duration(hours: 24)))
        ? "hours"
        : "min";
    return Row(
      children: [
        AppointmentTypeIndicatorWidget(
          height: height,
          width: width,
          type: type,
        ),
        const SizedBox(width: TAppSpacing.sm),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$typeName added : $title",
                textAlign: TextAlign.start,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                "${DateTime.now().difference(since).inHours} $sinceString ago",
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
