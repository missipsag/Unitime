import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/viewmodels/register_view_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key, required this.viewModel});

  final RegisterViewModel viewModel;
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late final ValueNotifier<bool> _isPasswordVisible;
  late final ValueNotifier<bool> _isConfirmPasswordVisible;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    widget.viewModel.register.removeListener(_handleRegisterError);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _isConfirmPasswordVisible = ValueNotifier<bool>(false);
    _isPasswordVisible = ValueNotifier<bool>(false);
    widget.viewModel.register.addListener(_handleRegisterError);
  }

  void _handleRegisterError() {
    if (widget.viewModel.register.error != null) {
      ThemeData theme = Theme.of(context);
      if (widget.viewModel.register.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "An error occurred when logging you in. Please try again later.",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onError,
              ),
            ),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        widget.viewModel.register.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Already have an account",
          style: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        titleSpacing: 0,
        foregroundColor: theme.colorScheme.onSurface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(overscroll: false),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to UniTime',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineLarge!.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    //const SizedBox(height: TAppSpacing.md),
                    SvgPicture.asset(
                      "assets/illustrations/girl_walking_on_books.svg",
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.9,
                    ),
                    const SizedBox(height: TAppSpacing.md),

                    // Champ Nom complet
                    TextFormField(
                      controller: _firstNameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hint: Text("First name"),
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainer,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'First name required';
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hint: Text("Last name"),
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainer,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Last name required';
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Champ Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainer,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email required';
                        }
                        if (!value.contains(
                          RegExp(r'^[a-zA-Z0-9_\.]+@[a-zA-Z0-9.-]+\.(com)$'),
                        )) {
                          return 'Invalid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Champ Mot de passe
                    ValueListenableBuilder(
                      valueListenable: _isPasswordVisible,
                      builder: (context, value, child) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible.value,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hint: Text('Password'),
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                value ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                _isPasswordVisible.value = !value;
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainer,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'password required';
                            }
                            if (value.length < 6) return '6 characters minimum';
                            return null;
                          },
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    // confirm password field
                    ValueListenableBuilder(
                      valueListenable: _isConfirmPasswordVisible,
                      builder: (context, value, child) {
                        return TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible.value,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hint: Text('Confirm password'),
                            prefixIcon: Icon(Icons.lock_open_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                value ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                _isConfirmPasswordVisible.value = !value;
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainer,
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            if (value!.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            if (!value.contains(
                              RegExp(
                                r'^[a-zA-Z0-9_@$*#&=+\?!|%ù!:;,<>\./çàèé-]+$',
                              ),
                            )) {
                              return "Password must contain : UpperCase,  Lowercase, special characters, numbers.";
                            }

                            return null;
                          },
                        );
                      },
                    ),
                    SizedBox(height: 32),

                    SizedBox(
                      width: screenWidth * 0.7,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.viewModel.register.execute(
                              _firstNameController.text,
                              _lastNameController.text,
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },

                        child: ListenableBuilder(
                          listenable: widget.viewModel.register,
                          builder: (context, child) {
                            if (widget.viewModel.register.running) {
                              return Center(
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: theme.colorScheme.onPrimary,
                                ),
                              );
                            } else {
                              return Text('Register');
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: TAppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
