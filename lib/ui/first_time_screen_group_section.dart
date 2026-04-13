import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/providers/session_provider.dart';
import 'package:unitime/repository/group_repository.dart';
import 'package:unitime/repository/user_repository.dart';
import 'package:unitime/ui/create_group_view.dart';
import 'package:unitime/viewmodels/create_group_view_model.dart';
import 'package:unitime/viewmodels/first_time_screen_group_view_model.dart';

class FirstTimeScreenGroupSection extends StatefulWidget {
  const FirstTimeScreenGroupSection({super.key, required this.viewModel});

  final FirstTimeScreenGroupViewModel viewModel;
  @override
  State<FirstTimeScreenGroupSection> createState() =>
      _FirstTimeScreenGroupSectionState();
}

class _FirstTimeScreenGroupSectionState
    extends State<FirstTimeScreenGroupSection> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _accessCodeController;

  @override
  void initState() {
    super.initState();
    _accessCodeController = TextEditingController();
    widget.viewModel.joinGroup.addListener(_handleGetPromotionError);
  }

  @override
  void dispose() {
    _accessCodeController.dispose();
    widget.viewModel.joinGroup.removeListener(_handleGetPromotionError);
    super.dispose();
  }

  void _handleGetPromotionError() {
    ThemeData theme = Theme.of(context);

    if (widget.viewModel.joinGroup.completed) {
      if (widget.viewModel.joinGroup.error != null ||
          widget.viewModel.errorMessage != null) {
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
        widget.viewModel.joinGroup.clear();
        widget.viewModel.clearErrorMessage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //final int promotionId = ModalRoute.of(context)!.settings.arguments as int;
    final int promotionId = 1;
    final ThemeData theme = Theme.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Join your group",
                  style: theme.textTheme.headlineLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SvgPicture.asset(
                  "assets/illustrations/Teaching-amico.svg",
                  height: screenHeight * 0.4,
                  width: screenWidth * 0.9,
                ),
                Text(
                  "Next, join your Group— this is the specific section you are placed in for your practical labs and smaller classes.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: TAppSpacing.lg),
                TextFormField(
                  controller: _accessCodeController,
                  decoration: InputDecoration(
                    hint: Text("Access code"),
                    prefixIcon: Icon(Icons.lock_open_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainer,
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please insert your promotion's access code.";
                    } else if (value.length < 6) {
                      return "Access codes must be at least 6 characters long.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TAppSpacing.md),
                SizedBox(
                  width: screenWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.viewModel.joinGroup.execute(
                          _accessCodeController.text,
                        );
                      }
                    },
                    child: ListenableBuilder(
                      listenable: widget.viewModel.joinGroup,
                      builder: (context, child) {
                        if (widget.viewModel.joinGroup.running) {
                          return Center(
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: theme.colorScheme.onPrimary,
                            ),
                          );
                        } else {
                          return const Text("Join group");
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: TAppSpacing.md),
                SizedBox(
                  width: screenWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => CreateGroupView(
                            viewModel: CreateGroupViewModel(
                              groupRepository: GroupRepository(),
                              userRepository: UserRepository(),
                              sessionProvider: context.read<SessionProvider>(),
                            ),
                          ),
                          settings: RouteSettings(arguments: promotionId),
                        ),
                      );
                    },
                    child: const Text("Create your own"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
