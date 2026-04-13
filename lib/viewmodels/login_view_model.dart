import 'package:flutter/material.dart';
import 'package:unitime/core/utils/command.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/user.dart';
import 'package:unitime/providers/session_provider.dart';
import 'package:unitime/repository/authentication_repository.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    required AuthenticationRepository authRepository,
    required SessionProvider sessionProvider,
  }) : _authRepository = authRepository,
       _sessionProvider = sessionProvider {
    login = Command2(_login);
  }

  final SessionProvider _sessionProvider;
  final AuthenticationRepository _authRepository;
  late final Command2<void, String, String> login;

  Future<Result<void>> _login(String username, String password) async {
    try {
      final user = await _authRepository.login(username, password);
      switch (user) {
        case Ok<User>():
          _sessionProvider.setUser(user.value);
          return Result.ok(null);

        case Error<User>():
          return Result.error(user.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
