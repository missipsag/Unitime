import 'package:flutter/material.dart';
import 'package:unitime/core/constants/promotion_level.dart';
import 'package:unitime/core/utils/command.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/promotion.dart';
import 'package:unitime/data/study_field.dart';
import 'package:unitime/providers/session_provider.dart';
import 'package:unitime/repository/promotion_repository.dart';
import 'package:unitime/repository/user_repository.dart';

class CreatePromotionViewModel extends ChangeNotifier {
  CreatePromotionViewModel({
    required PromotionRepository promotionRepository,
    required SessionProvider sessionProvider,
    required UserRepository userRepository,
  }) : _promotionRepository = promotionRepository,
       _sessionProvider = sessionProvider,
       _userRepository = userRepository {
    createPromotion = Command4(_createPromotion);
  }

  final PromotionRepository _promotionRepository;
  final SessionProvider _sessionProvider;
  final UserRepository _userRepository;

  late final Command4<void, String, String, PromotionLevel, StudyField>
  createPromotion;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<Result<void>> _createPromotion(
    String name,
    String accessCode,
    PromotionLevel level,
    StudyField field,
  ) async {
    _errorMessage = null;

    try {
      final res = await _promotionRepository.createPromotion(
        name,
        accessCode,
        level,
        field,
      );
      switch (res) {
        case Ok<Promotion>():
          await _userRepository.joinPromotion(res.value.id);
          _sessionProvider.setUserPromotion(res.value);
          _sessionProvider.getCurrentUser();
          return Result.ok(null);

        case Error<Promotion>():
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
    if (e is PromotionAlreadyExistsException) {
      return "A promotion with the same name or access code already exists. Please try again with a different name of access code.";
    } else {
      return "Could not create the promotion. Please try again later.";
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
  }
}
