import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitime/core/constants/app_routes.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/core/widgets/list_tile.dart';
import 'package:unitime/core/widgets/theme_switcher.dart';
import 'package:unitime/core/widgets/user_profile_widget.dart';
import 'package:unitime/data/user.dart';
import 'package:unitime/providers/session_provider.dart';
import 'package:unitime/ui/edit_personal_information_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ThemeMode _selectedTheme = ThemeMode.system;

  Future<void> _showPopUpMenu(BuildContext ctx) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = ctx.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<SessionProvider>().currentUser;

    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            //physics: ClampingScrollPhysics(),
            padding: const EdgeInsets.only(right: 20, left: 20, top: 30),
            child: Column(
              children: [
                //const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: UserProfileWidget(
                        initials:
                            "${user?.firstName[0].toUpperCase()}${user?.lastName[0].toUpperCase()}",
                        username: "${user?.firstName} ${user?.lastName}",
                        email: "${user?.email}",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TAppSpacing.md),

                Text(
                  "Preferences",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
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
                          icon: Icon(Icons.language),
                          onTap: (context) async {
                            await _showPopUpMenu(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Account",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      // modify account info
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CustomListTile(
                          title: "Personal info",
                          subtitle: "Edit your personal informations",
                          icon: Icon(Icons.account_circle_outlined),
                          onTap: (context) async {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) =>
                                    EditPersonalInformationView(),
                              ),
                            );
                          },
                        ),
                      ),
                      // privacy policy
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CustomListTile(
                          title: "Privacy support",
                          subtitle: "Privacy terms",
                          icon: Icon(Icons.contact_support_outlined),
                          onTap: (context) async {
                            if (await canLaunchUrl(
                              TAppRoutes.privacyAndSupportUrl,
                            )) {
                              await launchUrl(
                                TAppRoutes.privacyAndSupportUrl,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: TAppSpacing.md),
                      Text(
                        "Session",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: CustomListTile(
                          title: "Session",
                          subtitle: "Logout",
                          icon: Icon(
                            Icons.logout,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onTap: (context) async {
                            showDialog(
                              context: context,

                              builder: (context) => AlertDialog(
                                content: const Text(
                                  "Are you sure you want to log out ?",
                                ),
                                title: Text("Logging out"),

                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 0,
                                      ),
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.secondaryContainer,
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondary,
                                          ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      context.read<SessionProvider>().logout();

                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 0,
                                      ),
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.errorContainer,
                                    ),
                                    child: Text(
                                      "Log out",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onError,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
