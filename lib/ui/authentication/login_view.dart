import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/providers/session_provider.dart';
import 'package:unitime/repository/authentication_repository.dart';
import 'package:unitime/ui/authentication/register_view.dart';
import 'package:unitime/viewmodels/login_view_model.dart';
import 'package:unitime/viewmodels/register_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final ValueNotifier<bool> _isPasswordVisible;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isPasswordVisible.dispose();
    widget.viewModel.login.removeListener(_handleLoginError);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _isPasswordVisible = ValueNotifier<bool>(false);
    widget.viewModel.login.addListener(_handleLoginError);
  }

  void _handleLoginError() {
    ThemeData theme = Theme.of(context);
    if (widget.viewModel.login.error != null) {
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
      widget.viewModel.login.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: TAppSpacing.lg),
                  Text(
                    "Welcome back",
                    style: theme.textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: TAppSpacing.md),
                  SvgPicture.asset(
                    'assets/illustrations/Thesis-pana.svg',
                    height: screenHeight * 0.4,
                    width: screenWidth * 0.8,
                  ),
                  const SizedBox(height: TAppSpacing.xxl),

                  // Champ Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hint: Text('Email'),
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainer,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please insert a valid email.';
                      }
                      if (!value.contains(
                        RegExp(r'^[a-zA-Z0-9_\.]+@[a-zA-Z0-9.-]+\.(com)$'),
                      )) {
                        return 'Invalid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: TAppSpacing.md),

                  // Champ Mot de passe
                  ValueListenableBuilder(
                    valueListenable: _isPasswordVisible,
                    builder: (context, bool val, child) {
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible.value,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hint: Text('Password'),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              val ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              _isPasswordVisible.value =
                                  !_isPasswordVisible.value;
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
                            return 'Please insert a password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          } else if (!value.contains(
                            RegExp(
                              r'^[a-zA-Z0-9_@$*#&=+\?!|%ù!:;,<>\./çàèé-]+$',
                            ),
                          )) {
                            return "Password must contain : UpperCase, Lowercase, special characters, numbers.";
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  SizedBox(height: TAppSpacing.md),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Navigation vers mot de passe oublié
                      },
                      child: Text('Forgot your password ?'),
                    ),
                  ),
                  SizedBox(height: TAppSpacing.md),

                  SizedBox(
                    width: screenWidth * 0.7,

                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Logique de connexion
                          final email = _emailController.text;
                          final password = _passwordController.text;

                          widget.viewModel.login.execute(email, password);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide.none,
                        ),
                        elevation: 2,
                      ),
                      child: ListenableBuilder(
                        listenable: widget.viewModel.login,
                        builder: (context, child) {
                          if (widget.viewModel.login.running) {
                            return Center(
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: theme.colorScheme.onPrimary,
                              ),
                            );
                          } else {
                            return Text(
                              'Login',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: TAppSpacing.sm),

                  // Lien vers Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account ?"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RegisterView(
                                viewModel: RegisterViewModel(
                                  authRepository: AuthenticationRepository(),
                                  sessionProvider: context.read<SessionProvider>()
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'register here.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
