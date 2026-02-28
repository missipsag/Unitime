import 'package:flutter/material.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    super.key,
    required this.height,
    required this.width,
    required this.progress,
  });

  final double progress;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height * 0.08,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        Container(
          // set height and widht to be the default max
          width: width - ((100 - progress) * width) / 100,
          height: height * 0.08,

          // adjust margin dependin on the progress to show progress bar
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            // adapt the color to the time passed
            color: progress < 25.0
                ? Colors.green
                : progress < 50.0
                ? Colors.orangeAccent
                : Colors.redAccent,
          ),
        ),
      ],
    );
  }
}
