import 'package:flutter/material.dart';

class FirstTimeScreenPromotionSection extends StatefulWidget {
  const FirstTimeScreenPromotionSection({super.key});

  @override
  State<FirstTimeScreenPromotionSection> createState() =>
      _FirstTimeScreenPromotionSectionState();
}

class _FirstTimeScreenPromotionSectionState
    extends State<FirstTimeScreenPromotionSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      // alignment: AlignmentGeometry.directional(0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 100.0,
        children: [
          Text(
            "Stay in sync with your promotion",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              
              spacing: 8.0,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadiusGeometry.all(
                        Radius.circular(5),
                      ),
                    ),

                    elevation: 4.0,
                  ),
                  child: const Text("Join a promotion"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,

                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadiusGeometry.all(
                        Radius.circular(5),
                      ),
                    ),
                    elevation: 4.0,
                  ),
                  child: const Text("Create a promotion"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
