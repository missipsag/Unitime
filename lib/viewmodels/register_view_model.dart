import 'package:flutter/foundation.dart';
import 'package:unitime/core/utils/command.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/user.dart';
import 'package:unitime/providers/session_provider.dart';
import 'package:unitime/repository/authentication_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  RegisterViewModel({
    required AuthenticationRepository authRepository,
    required SessionProvider sessionProvider,
  }) : _authRepository = authRepository,
       _sessionProvider = sessionProvider {
    register = Command4(_register);
  }

  // ignore: unused_field
  final AuthenticationRepository _authRepository;
  final SessionProvider _sessionProvider;

  late final Command4<void, String, String, String, String> register;

  Future<Result<void>> _register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      final user = await _authRepository.register(
        email,
        password,
        firstName,
        lastName,
      );
      switch (user) {
        case Ok<User>():
          _sessionProvider.setUser(user.value);
          return Result.ok(null);

        case Error<User>():
          return user;
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
