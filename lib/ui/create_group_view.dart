import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/viewmodels/create_group_view_model.dart';

class CreateGroupView extends StatefulWidget {
  const CreateGroupView({super.key, required this.viewModel});

  final CreateGroupViewModel viewModel;

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  late final TextEditingController _groupNameController;
  late final TextEditingController _groupAccessCodeController;

  @override
  void initState() {
    super.initState();
    _groupAccessCodeController = TextEditingController();
    _groupNameController = TextEditingController();
    widget.viewModel.createGroup.addListener(_handleCreateGroupCompletion);
  }

  @override
  void dispose() {
    _groupAccessCodeController.dispose();
    _groupNameController.dispose();

    widget.viewModel.createGroup.removeListener(_handleCreateGroupCompletion);
    super.dispose();
  }

  void _handleCreateGroupCompletion() {
    ThemeData theme = Theme.of(context);

    if (widget.viewModel.createGroup.completed) {
      if (widget.viewModel.createGroup.error != null ||
          widget.viewModel.errorMessage != null) {
        // Handle error
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.viewModel.errorMessage ??
                  "Something went wrong. Please try again later.",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onError,
              ),
            ),
            elevation: 2,
            action: SnackBarAction(
              label: "Got it",
              textColor: theme.colorScheme.onError,
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              },
            ),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        widget.viewModel.createGroup.clear();
        widget.viewModel.clearErrorMessage();
      } else {
        // Handle success
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "group created successfully!",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
            ),
            elevation: 2,
            backgroundColor: theme.colorScheme.secondary,
          ),
        );
        widget.viewModel.createGroup.clear();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int groupId = ModalRoute.of(context)!.settings.arguments as int;
    ThemeData theme = Theme.of(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.chevron_left),
        ),
        title: Text(
          "Join a group",
          style: theme.textTheme.headlineMedium!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 12, right: 12, left: 12),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Create you own group",
                      style: theme.textTheme.headlineMedium!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: TAppSpacing.md),
                  SvgPicture.asset(
                    'assets/illustrations/Seminar-bro.svg',
                    height: screenHeight * 0.3,
                    width: screenWidth * 0.6,
                  ),
                  const SizedBox(height: TAppSpacing.xxl),

                  TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      hint: Text("group name"),
                      prefixIcon: Icon(Icons.language),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainer,
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide a valid group name.";
                      }
                      if (value.length < 4) {
                        return "group name must be at least 4 characters long.";
                      }
                      if (!value.contains(
                        RegExp(r'^[A-Za-z]+[A-Za-z_]*[0-9]*$'),
                      )) {
                        return "The only characters allowed are Alphanumerical and _ .";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: TAppSpacing.md),
                  TextFormField(
                    controller: _groupAccessCodeController,
                    decoration: InputDecoration(
                      hint: Text("group access code"),
                      prefixIcon: Icon(Icons.lock_open),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainer,
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide a valid group access code.";
                      }
                      if (value.isNotEmpty) {
                        final newVal = value.trim();
                        if (newVal.length < 6) {
                          return "Group access code must be at least 6 characters long.";
                        }
                        if (!newVal.contains(
                          RegExp(
                            r'^[A-Za-z]+[A-Za-z_]*[0-9A-Za-z_@$!?;:/\\#&=+£µ%ù§]*$',
                          ),
                        )) {
                          return "The only characters allowed are Alphanumerical and special characters : _ @ \$ ! ? ; :/ \\ # & = + £ µ % ù § .";
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: TAppSpacing.md),

                  SizedBox(height: TAppSpacing.md),

                  SizedBox(
                    width: screenWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          widget.viewModel.createGroup.execute(
                            _groupNameController.text,
                            _groupAccessCodeController.text,
                            groupId,
                          );
                        }
                      },
                      child: ListenableBuilder(
                        listenable: widget.viewModel.createGroup,
                        builder: (context, child) {
                          if (widget.viewModel.createGroup.running) {
                            return Center(
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: theme.colorScheme.onPrimary,
                              ),
                            );
                          } else {
                            return Text(
                              'Create group',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
