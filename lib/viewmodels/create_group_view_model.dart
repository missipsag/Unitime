import 'package:flutter/material.dart';
import 'package:unitime/core/utils/command.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/group.dart';
import 'package:unitime/providers/session_provider.dart';
import 'package:unitime/repository/group_repository.dart';
import 'package:unitime/repository/user_repository.dart';

class CreateGroupViewModel extends ChangeNotifier {
  CreateGroupViewModel({
    required GroupRepository groupRepository,
    required UserRepository userRepository,
    required SessionProvider sessionProvider,
  }) : _groupRepository = groupRepository,
       _userRepository = userRepository,
       _sessionProvider = sessionProvider {
    createGroup = Command3(_createGroup);
  }

  final GroupRepository _groupRepository;
  final UserRepository _userRepository;
  final SessionProvider _sessionProvider;

  late final Command3<void, String, String, int> createGroup;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<Result<void>> _createGroup(
    String name,
    String accessCode,
    int groupId,
  ) async {
    _errorMessage = null;

    try {
      final res = await _groupRepository.createGroup(name, accessCode, groupId);
      switch (res) {
        case Ok<Group>():
          await _userRepository.joinGroup(res.value.id);
          _sessionProvider.setUserGroup(res.value);
          return Ok(null);

        case Error<Group>():
          _errorMessage = _handleError(res.error);
          return Result.error(res.error);
      }
    } on Exception catch (e) {
      _errorMessage = "Something went wrong. Please try again later.";
      return Result.error(e);
    }
  }

  String _handleError(Exception e) {
    if (e is NoInternetException) {
      return "Please check your internet connection and try again.";
    }
    if (e is UnauthorizedException ||
        e is UserNotAuthenticatedAuthException ||
        e is NoValueAssociatedWithKeyException) {
      return "Your session expired. Please log in again.";
    }
    if (e is RateLimitException) {
      return "Seems like you exceeded the rate limit. Try again in a moment.";
    }
    if (e is DataParsingException) {
      return "Seems like the group name or access code you provided is invalid.";
    }
    if (e is GroupAlreadyExistsException) {
      return "A group with the same name or access code already exists. Please provide a different name or access code.";
    }
    if (e is NetworkTimeoutException) {
      return "We failed to create the group in time. Please try again later.";
    }
    {
      return "Could not create the group. Please try again later.";
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
  }
}
