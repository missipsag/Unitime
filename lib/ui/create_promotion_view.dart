import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/core/constants/promotion_level.dart';
import 'package:unitime/data/study_field.dart';
import 'package:unitime/viewmodels/create_promotion_view_model.dart';

class CreatePromotionView extends StatefulWidget {
  const CreatePromotionView({super.key, required this.viewModel});

  final CreatePromotionViewModel viewModel;

  @override
  State<CreatePromotionView> createState() => _CreatePromotionViewState();
}

class _CreatePromotionViewState extends State<CreatePromotionView> {
  late final TextEditingController _promotionNameController;
  late final TextEditingController _promotionAccessCodeController;
  late final ValueNotifier<PromotionLevel> _selectedLevel;
  late final ValueNotifier<StudyField> _selectedField;

  @override
  void initState() {
    super.initState();
    _promotionAccessCodeController = TextEditingController();
    _promotionNameController = TextEditingController();
    _selectedLevel = ValueNotifier<PromotionLevel>(PromotionLevel.L1);
    _selectedField = ValueNotifier<StudyField>(StudyField.computerScience);
    widget.viewModel.createPromotion.addListener(
      _handleCreatePromotionCompletion,
    );
  }

  @override
  void dispose() {
    _promotionAccessCodeController.dispose();
    _promotionNameController.dispose();
    _selectedLevel.dispose();
    _selectedField.dispose();
    widget.viewModel.createPromotion.removeListener(
      _handleCreatePromotionCompletion,
    );
    super.dispose();
  }

  void _handleCreatePromotionCompletion() {
    ThemeData theme = Theme.of(context);

    if (widget.viewModel.createPromotion.completed) {
      if (widget.viewModel.createPromotion.error != null ||
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
        widget.viewModel.createPromotion.clear();
        widget.viewModel.clearErrorMessage();
      } else {
        // Handle success
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Promotion created successfully!",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
            ),
            elevation: 2,
            backgroundColor: theme.colorScheme.secondary,
          ),
        );
        widget.viewModel.createPromotion.clear();
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
          "Join a promotion",
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
                      "Create you own promotion",
                      style: theme.textTheme.headlineMedium!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: TAppSpacing.md),
                  SvgPicture.asset(
                    'assets/illustrations/college class-amico.svg',
                    height: screenHeight * 0.3,
                    width: screenWidth * 0.6,
                  ),
                  const SizedBox(height: TAppSpacing.xxl),

                  TextFormField(
                    controller: _promotionNameController,
                    decoration: InputDecoration(
                      hint: Text("Promotion name"),
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
                        return "Please provide a valid promotion name.";
                      }
                      if (value.length < 4) {
                        return "Promotion name must be at least 4 characters long.";
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
                    controller: _promotionAccessCodeController,
                    decoration: InputDecoration(
                      hint: Text("Promotion access code"),
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
                        return "Please provide a valid promotion access code.";
                      }
                      if (value.isNotEmpty) {
                        final newVal = value.trim();
                        if (newVal.length < 6) {
                          return "Promotion access code must be at least 6 characters long.";
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
                  ValueListenableBuilder<StudyField>(
                    valueListenable: _selectedField,
                    builder: (context, field, child) {
                      return DropdownButtonFormField<StudyField>(
                        decoration: InputDecoration(
                          hintText: "Field of Study",
                          prefixIcon: Icon(Icons.school),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainer,
                        ),
                        items: StudyField.values
                            .map<DropdownMenuItem<StudyField>>(
                              (field) => DropdownMenuItem<StudyField>(
                                value: field,
                                child: Text(field.displayName),
                              ),
                            )
                            .toList(),
                        onChanged: (StudyField? val) {
                          if (val != null) {
                            _selectedField.value = val;
                          }
                        },
                        initialValue: field,
                        dropdownColor: theme.colorScheme.surfaceContainer,
                      );
                    },
                  ),
                  SizedBox(height: TAppSpacing.md),
                  ValueListenableBuilder<PromotionLevel>(
                    valueListenable: _selectedLevel,
                    builder: (context, level, child) {
                      return DropdownButtonFormField<PromotionLevel>(
                        decoration: InputDecoration(
                          hintText: "Level",
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainer,
                        ),
                        items: PromotionLevel.values
                            .map<DropdownMenuItem<PromotionLevel>>(
                              (enumLevel) => DropdownMenuItem<PromotionLevel>(
                                value: enumLevel,
                                child: Text(enumLevel.name),
                              ),
                            )
                            .toList(),
                        onChanged: (PromotionLevel? val) {
                          if (val != null) {
                            _selectedLevel.value = val;
                          }
                        },
                        initialValue: level,
                        dropdownColor: theme.colorScheme.surfaceContainer,
                      );
                    },
                  ),
                  SizedBox(height: TAppSpacing.md),
                  SizedBox(
                    width: screenWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          widget.viewModel.createPromotion.execute(
                            _promotionNameController.text,
                            _promotionAccessCodeController.text,
                            _selectedLevel.value,
                            _selectedField.value,
                          );
                        }
                      },
                      child: ListenableBuilder(
                        listenable: widget.viewModel.createPromotion,
                        builder: (context, child) {
                          if (widget.viewModel.createPromotion.running) {
                            return Center(
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: theme.colorScheme.onPrimary,
                              ),
                            );
                          } else {
                            return Text(
                              'Create promotion',
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
