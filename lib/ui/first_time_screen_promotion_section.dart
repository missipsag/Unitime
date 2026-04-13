import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/providers/session_provider.dart';
import 'package:unitime/repository/promotion_repository.dart';
import 'package:unitime/repository/user_repository.dart';
import 'package:unitime/ui/create_promotion_view.dart';
import 'package:unitime/viewmodels/create_promotion_view_model.dart';
import 'package:unitime/viewmodels/first_time_screen_promotion_view_model.dart';

class FirstTimeScreenPromotionSection extends StatefulWidget {
  const FirstTimeScreenPromotionSection({super.key, required this.viewModel});

  final FirstTimeScreenPromotionViewModel viewModel;
  @override
  State<FirstTimeScreenPromotionSection> createState() =>
      _FirstTimeScreenPromotionSectionState();
}

class _FirstTimeScreenPromotionSectionState
    extends State<FirstTimeScreenPromotionSection> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _accessCodeController;

  @override
  void initState() {
    super.initState();
    _accessCodeController = TextEditingController();
    widget.viewModel.getPromotion.addListener(_handleGetPromotionError);
  }

  @override
  void dispose() {
    _accessCodeController.dispose();
    widget.viewModel.getPromotion.removeListener(_handleGetPromotionError);
    super.dispose();
  }

  void _handleGetPromotionError() {
    ThemeData theme = Theme.of(context);

    if (widget.viewModel.getPromotion.completed) {
      if (widget.viewModel.getPromotion.error != null ||
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
        widget.viewModel.getPromotion.clear();
        widget.viewModel.clearErrorMessage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  "Join your promotion",
                  style: theme.textTheme.headlineLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SvgPicture.asset(
                  "assets/illustrations/college class-bro.svg",
                  height: screenHeight * 0.4,
                  width: screenWidth * 0.9,
                ),
                Text(
                  "First, choose your Promotion—this is your current academic year and major.",
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
                        widget.viewModel.getPromotion.execute(
                          _accessCodeController.text,
                        );
                      }
                    },
                    child: ListenableBuilder(
                      listenable: widget.viewModel.getPromotion,
                      builder: (context, child) {
                        if (widget.viewModel.getPromotion.running) {
                          return Center(
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: theme.colorScheme.onPrimary,
                            ),
                          );
                        } else {
                          return const Text("Join promotion");
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
                          builder: (context) => CreatePromotionView(
                            viewModel: CreatePromotionViewModel(
                              promotionRepository: PromotionRepository(),
                              sessionProvider: context.read<SessionProvider>(),
                              userRepository: UserRepository()
                            ),
                          ),
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
