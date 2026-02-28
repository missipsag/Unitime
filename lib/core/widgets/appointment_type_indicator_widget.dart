import 'package:flutter/material.dart';
import 'package:unitime/core/constants/colors.dart';
import 'package:unitime/core/constants/uni_appointment_type.dart';

class AppointmentTypeIndicatorWidget extends StatelessWidget {
  const AppointmentTypeIndicatorWidget({
    super.key,
    required this.height,
    required this.width,
    required this.type,
  });

  final double height;
  final double width;
  final UniAppointmentType type;

  @override
  Widget build(BuildContext context) {
    final String indicator;
    if (type == UniAppointmentType.COURSE) {
      indicator = "CM";
    } else if (type == UniAppointmentType.SPECIAL_EVENT) {
      indicator = "SE";
    } else {
      indicator = type.name;
    }
    final Color color = appointementColor[type]!;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100), // Barely visible shadow
            blurRadius: 10,
            offset: const Offset(0, 4), // Pushes the shadow down slightly
          ),
        ],

        color: color.withAlpha(230),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          indicator,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
