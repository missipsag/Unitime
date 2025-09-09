import 'package:flutter/material.dart';
import 'package:unitime/core/widgets/list_tile.dart';
import 'package:unitime/core/widgets/theme_switcher.dart';
import 'package:unitime/core/widgets/user_profile_widget.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final IconData _darkMode = Icons.dark_mode;
  final IconData _lightMode = Icons.light_mode;
  final IconData _sysMode = Icons.settings;
  late IconData _selectedThemeIcon;
  final List _languages = ["FR", "EN"];
  final double _paddingH = 10;
  final double _paddingV = 8;

  ThemeMode _selectedTheme = ThemeMode.light;

  Future<void> _showPopUpMenu(BuildContext ctx) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = ctx.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + button.size.width,
        position.dy + button.size.height,
        overlay.size.width - position.dx - button.size.width,
        overlay.size.height - position.dy - button.size.height,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: const [
        PopupMenuItem(value: "Fr", child: Text("Fr")),
        PopupMenuItem(value: "En", child: Text("En")),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedThemeIcon = _sysMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            UserProfileWidget(
              initials: "IS",
              username: "Its shoyo",
              email: "lkqfjldkjflkdj",
            ),
            const SizedBox(height: 20),

            const Text("Preferences", textAlign: TextAlign.start),
            //const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),

              child: Column(
                spacing: 10,
                children: [
                  ThemeSwitcherCard(
                    currentMode: _selectedTheme,
                    onModeChanged: (mode) {
                      setState(() {
                        _selectedTheme = mode;
                      });
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomListTile(
                      title: "Language",
                      subtitle: "English",
                      icon: Icons.language,
                      onTap: (context) async {
                        await _showPopUpMenu(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Account", textAlign: TextAlign.center),

                  // modify account info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomListTile(
                      title: "Edit account",
                      subtitle: "Edit your personal information",
                      icon: Icons.account_circle_outlined,
                      onTap: (context) async {},
                    ),
                  ),
                  // privacy policy
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomListTile(
                      title: "Privacy support",
                      subtitle: "Privacy terms",
                      icon: Icons.contact_support_outlined,
                      onTap: (context) async {},
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Session", textAlign: TextAlign.center),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomListTile(
                      title: "Session",
                      subtitle: "Logout",
                      icon: Icons.logout,
                      onTap: (context) async {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
