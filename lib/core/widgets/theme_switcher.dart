import 'package:flutter/material.dart';

class ThemeSwitcherCard extends StatelessWidget {
  final ThemeMode currentMode;
  final Function(ThemeMode) onModeChanged;

  const ThemeSwitcherCard({
    Key? key,
    required this.currentMode,
    required this.onModeChanged,
  }) : super(key: key);

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
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.wb_sunny, color: Colors.deepPurple),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Appearance",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _getSubtitle(),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Buttons
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildModeButton(
                    icon: Icons.wb_sunny,
                    isSelected: currentMode == ThemeMode.light,
                    onTap: () => onModeChanged(ThemeMode.light),
                  ),
                  _buildModeButton(
                    icon: Icons.nights_stay,
                    isSelected: currentMode == ThemeMode.dark,
                    onTap: () => onModeChanged(ThemeMode.dark),
                  ),
                  _buildModeButton(
                    icon: Icons.settings,
                    isSelected: currentMode == ThemeMode.system,
                    onTap: () => onModeChanged(ThemeMode.system),
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
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  static String _getSubtitle() {
    return "Mode clair activé"; // Could be dynamic
  }
}
