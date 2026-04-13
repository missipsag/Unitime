import 'package:flutter/material.dart';
import 'package:unitime/core/utils/command.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/group.dart';
import 'package:unitime/providers/session_provider.dart';
import 'package:unitime/repository/group_repository.dart';
import 'package:unitime/repository/user_repository.dart';

class FirstTimeScreenGroupViewModel extends ChangeNotifier {
  final GroupRepository _groupRepository;
  final UserRepository _userRepository;
  final SessionProvider _sessionProvider;

  FirstTimeScreenGroupViewModel({
    required GroupRepository groupRepository,
    required UserRepository userRepository,
    required SessionProvider sessionProvider,
  }) : _groupRepository = groupRepository,
       _userRepository = userRepository,
       _sessionProvider = sessionProvider {
    joinGroup = Command1(_joinGroup);
  }

  late final Command1<void, String> joinGroup;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Group? _group;
  Group? get group => _group;

  Future<Result<void>> _joinGroup(String accessCode) async {
    _errorMessage = null;
    try {
      final res = await _groupRepository.getGroup(accessCode);
      switch (res) {
        case Ok<Group>():
          _group = res.value;
          _sessionProvider.setUserGroup(_group!);
          await _userRepository.joinGroup(_group!.id);
          return Result.ok(null);

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
      return "Seems like the promotion name or access code you provided is invalid.";
    }
    if (e is NetworkTimeoutException) {
      return "We failed to create the promotion in time. Please try again later.";
    }
    if (e is GroupNotFoundException) {
      return "This group access code is invalid or expired.";
    }
    if (e is GroupNotFoundException) {
      return "The access code you provided doesn't map to any group. Please try again with a valid one.";
    }
    {
      return "Could not join the group. Please try again later.";
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
  }
}
