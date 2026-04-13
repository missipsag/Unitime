import 'package:flutter/material.dart';
import 'package:unitime/core/utils/command.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/promotion.dart';
import 'package:unitime/providers/session_provider.dart';
import 'package:unitime/repository/promotion_repository.dart';

class FirstTimeScreenPromotionViewModel extends ChangeNotifier {
  FirstTimeScreenPromotionViewModel({
    required PromotionRepository promotionRepository,
    required SessionProvider sessionProvider,
  }) : _promotionRepository = promotionRepository,
       _sessionProvider = sessionProvider {
    getPromotion = Command1(_getPromotion);
  }

  final SessionProvider _sessionProvider;
  final PromotionRepository _promotionRepository;

  late final Command1<void, String> getPromotion;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Promotion? _promotion;
  Promotion? get promotion => _promotion;

  Future<Result<void>> _getPromotion(String accessCode) async {
    _errorMessage = null;

    try {
      final res = await _promotionRepository.getPromotion(accessCode);
      //await Future.delayed(const Duration(seconds: 2));
      switch (res) {
        case Ok<Promotion>():
          _promotion = res.value;
          _sessionProvider.setUserPromotion(_promotion!);
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
      return "Please check you internet connection and try again.";
    }
    if (e is UnauthorizedException ||
        e is UserNotAuthenticatedAuthException ||
        e is NoValueAssociatedWithKeyException) {
      return "Your session expired. Please log in again.";
    }
    if (e is PromotionNotFoundException) {
      return "This promotion code is invalid or expired.";
    }
    if (e is RateLimitException) {
      return "Seems like you exceeded the rate limit. Try again in a moment.";
    }
    if (e is DataParsingException) {
      return "Seems like the access code you provided is invalid.";
    }

    if (e is PromotionNotFoundException) {
      return "The access code you provided doesn't map to any promotion. Please try again with a valid one.";
    }
    if (e is NetworkTimeoutException) {
      return "We failed to get the promotion data in time. Please try again later.";
    }
    {
      return "Could not fetch the promotion. Please try again later.";
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
  }
}
