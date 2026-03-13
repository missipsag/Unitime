import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unitime/core/constants/app_spacing.dart';

class EmptyStateWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? description;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.imagePath,
    required this.title,
    this.description,
    required this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // The SVG Illustration
            SvgPicture.asset(
              imagePath,
              height: 100, // Keep illustrations uniform in size
            ),
            const SizedBox(height: TAppSpacing.md),

            // The Headline
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TAppSpacing.sm),

            // The Description
            if (description != null && description!.isNotEmpty) ...[
              Text(
                description!,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: TAppSpacing.sm),

            // The Call-to-Action Button
            if (onButtonPressed != null) ...[
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ), // Full-width button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(buttonText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
