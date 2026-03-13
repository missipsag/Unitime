import 'package:flutter/material.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/core/widgets/appointment_list_tile_widget.dart';
import 'package:unitime/core/widgets/empty_state_widget.dart';
import 'package:unitime/core/widgets/event_list_tile_widget.dart';
import 'package:unitime/data/uni_appointment.dart';
import 'package:unitime/ui/updates_view.dart';
import 'package:unitime/viewmodels/feed_view_model.dart';
import 'package:unitime/viewmodels/updates_view_model.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key, required this.viewModel});

  final FeedViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, screenHeight, screenWidth),
                const SizedBox(height: 10),
                _buildSectionTitle(context, 'Current appointments'),
                const SizedBox(height: TAppSpacing.md),
                ListenableBuilder(
                  listenable: viewModel.loadCurrAppointments,
                  builder: (context, child) {
                    if (viewModel.loadCurrAppointments.running) {
                      return const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator.adaptive(),
                            Text("Loading current appointments..."),
                          ],
                        ),
                      );
                    }
                    if (viewModel.loadCurrAppointments.error != null) {
                      return const Center(
                        child: Text("Ouups an error Occured"),
                      );
                    }

                    if (viewModel.currAppointments.isEmpty) {
                      return const EmptyStateWidget(
                        imagePath: 'assets/illustrations/two_blank_pages.svg',
                        title: 'Enjoy your free time !',
                        buttonText: 'Press',
                      );
                    }
                    return _buildAppointmentsList(
                      context,
                      screenHeight,
                      screenWidth,
                      viewModel.currAppointments,
                    );
                  },
                ),

                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Upcoming special events'),
                const SizedBox(height: 16),
                ListenableBuilder(
                  listenable: viewModel.loadUpcomingSpecialEvents,
                  builder: (context, child) {
                    if (viewModel.loadUpcomingSpecialEvents.running) {
                      return const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator.adaptive(),
                            Text("Loading upcoming special events..."),
                          ],
                        ),
                      );
                    } else if (viewModel.loadUpcomingSpecialEvents.error !=
                        null) {
                      return Center(
                        child: const Text("Ouups an error Occured"),
                      );
                    } else if (viewModel.upcomingSpecialEvents.isEmpty) {
                      return const EmptyStateWidget(
                        imagePath: 'assets/illustrations/two_blank_pages.svg',
                        title: 'No special events',
                        buttonText: 'Press',
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...viewModel.upcomingSpecialEvents.map(
                            (app) => EventListTileWidget(
                              height: screenHeight,
                              width: screenWidth,
                              app: app,
                            ),
                          ),
                        ],
                      );
                    }
                    // return _buildEventsList(
                    //   context,
                    //   screenHeight,
                    //   screenWidth,
                    //   viewModel.upcomingSpecialEvents,
                    // );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Top Section: Avatar and Greeting
  Widget _buildHeader(
    BuildContext context,
    double screenHeight,
    double screenWidth,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              children: [
                SizedBox(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.1,

                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    backgroundImage: NetworkImage(
                      'https://ui-avatars.com/api/?name=Missipsa+Ghernaout',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: screenWidth * 0.5,
                  child: Text(
                    style: Theme.of(context).textTheme.headlineMedium!,
                    'Missipsa Ghernaout',
                  ),
                ),
                const Expanded(flex: 3, child: SizedBox(width: 10)),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) =>
                            UpdatesView(viewModel: UpdatesViewModel()),
                      ),
                    );
                  },
                  icon: Icon(color: Colors.grey, Icons.notifications),
                ),
              ],
            );
          },
        ),
        SizedBox(height: screenHeight * 0.04),
        Text(
          "Ready for class ?",
          style: Theme.of(context).textTheme.headlineLarge!,
        ),
      ],
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.headlineMedium!);
  }

  // 2. Middle Section: Horizontal List
  Widget _buildAppointmentsList(
    BuildContext context,
    double screenHeight,
    double screenWidth,
    List<UniAppointment> apps,
  ) {
    double appointmentContainerWidth = screenWidth * 0.8;
    double appointmentContainerHeight = screenHeight * 0.18;
    return SizedBox(
      height: appointmentContainerHeight, // Fixed height for horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: apps.length, // Replace with your actual data length
        itemBuilder: (context, index) {
          UniAppointment app = apps[index];
          return AppointmentListTileWidget(
            height: appointmentContainerHeight,
            width: appointmentContainerWidth,
            app: app,
          );
        },
      ),
    );
  }

  // 3. Bottom Section: Vertical List
  Widget _buildEventsList(
    BuildContext context,
    double screenHeight,
    double screenWidth,
    List<UniAppointment> apps,
  ) {
    return Expanded(
      child: SizedBox(
        height: screenHeight * 0.5,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          scrollDirection: Axis
              .vertical, // Needed because it's inside a SingleChildScrollView
          itemCount: apps.length, // Replace with your actual data length
          itemBuilder: (context, index) {
            UniAppointment app = apps[index];
            return EventListTileWidget(
              height: screenHeight,
              width: screenWidth,
              app: app,
            );
          },
        ),
      ),
    );
  }
}
