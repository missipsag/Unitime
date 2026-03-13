import 'package:flutter/material.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/core/widgets/empty_state_widget.dart';
import 'package:unitime/core/widgets/updates_appointment_list_tile.dart';
import 'package:unitime/viewmodels/updates_view_model.dart';

class UpdatesView extends StatefulWidget {
  const UpdatesView({super.key, required this.viewModel});
  final UpdatesViewModel viewModel;
  @override
  State<UpdatesView> createState() => _UpdatesViewState();
}

class _UpdatesViewState extends State<UpdatesView> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appIndicatorHeight = screenHeight * 0.07;
    final double appIndicatorWidth = screenWidth * 0.15;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          color: Theme.of(context).colorScheme.onSecondary,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "home page",

          style: Theme.of(context).textTheme.bodyMedium!,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: TAppSpacing.md),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Notifications",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        widget.viewModel.clearUpdates.execute();
                      },
                      child: Text(
                        "clear",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: TAppSpacing.md),
                ListenableBuilder(
                  listenable: Listenable.merge([
                    widget.viewModel.clearUpdates,
                    widget.viewModel.loadUpdates,
                  ]),
                  builder: (context, child) {
                    if (widget.viewModel.loadUpdates.running) {
                      return const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator.adaptive(),
                            Text("Loading..."),
                          ],
                        ),
                      );
                    } else if (widget.viewModel.loadUpdates.error != null) {
                      return Center(
                        child: const Text(("Ouupss, something went wrong")),
                      );
                    } else if (widget.viewModel.updatedAppoitments.isEmpty) {
                      return EmptyStateWidget(
                        imagePath: "assets/illustrations/two_blank_pages.svg",
                        title: 'Nothing here.',
                        buttonText: "reload",
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today",
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: TAppSpacing.sm),
                          ...widget.viewModel.updatedAppoitments
                              .where(
                                (app) =>
                                    widget.viewModel.updatedAppoitments.indexOf(
                                      app,
                                    ) <
                                    2,
                              )
                              .map(
                                (app) => Container(
                                  margin: EdgeInsets.only(
                                    bottom: TAppSpacing.sm,
                                  ),
                                  child: UpdatesAppointmentListTile(
                                    height: appIndicatorHeight,
                                    width: appIndicatorWidth,
                                    type: app.uniAppointmentType,
                                    title: app.title,
                                    since: DateTime.now().subtract(
                                      Duration(
                                        hours:
                                            widget.viewModel.updatedAppoitments
                                                .indexOf(app) +
                                            1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          Text(
                            "Yesterday",
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: TAppSpacing.sm),
                          ...widget.viewModel.updatedAppoitments
                              .where(
                                (app) =>
                                    widget.viewModel.updatedAppoitments.indexOf(
                                      app,
                                    ) >=
                                    2,
                              )
                              .map(
                                (app) => Container(
                                  margin: EdgeInsets.only(
                                    bottom: TAppSpacing.sm,
                                  ),
                                  child: UpdatesAppointmentListTile(
                                    height: appIndicatorHeight,
                                    width: appIndicatorWidth,
                                    type: app.uniAppointmentType,
                                    title: app.title,
                                    since: DateTime.now().subtract(
                                      Duration(
                                        hours:
                                            widget.viewModel.updatedAppoitments
                                                .indexOf(app) +
                                            24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

