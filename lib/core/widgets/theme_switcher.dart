import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/core/utils/theme_provider.dart';

class ThemeSwitcherCard extends StatelessWidget {
  final ThemeMode currentMode;
  final Function(ThemeMode) onModeChanged;

  const ThemeSwitcherCard({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // Title + Subtitle
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.wb_sunny,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: TAppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Appearance",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Theme',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TAppSpacing.md),

            // Buttons
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildModeButton(
                    context: context,
                    icon: Icons.wb_sunny,
                    isSelected: currentMode == ThemeMode.light,
                    onTap: () {
                      onModeChanged(ThemeMode.light);
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).setThemeMode(ThemeMode.light);
                    },
                  ),
                  _buildModeButton(
                    context: context,
                    icon: Icons.nights_stay,
                    isSelected: currentMode == ThemeMode.dark,
                    onTap: () {
                      onModeChanged(ThemeMode.dark);
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).setThemeMode(ThemeMode.dark);
                    },
                  ),
                  _buildModeButton(
                    context: context,
                    icon: Icons.settings,
                    isSelected: currentMode == ThemeMode.system,
                    onTap: () {
                      onModeChanged(ThemeMode.system);
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).setThemeMode(ThemeMode.system);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton({
    required BuildContext context,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}
