import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:unitime/core/constants/app_routes.dart';
import 'package:unitime/core/constants/promotion_level.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/promotion.dart';
import 'package:unitime/data/study_field.dart';

class PromotionService {
  static final PromotionService _shared = PromotionService._sharedInstance();

  PromotionService._sharedInstance();

  factory PromotionService() => _shared;

  Future<Result<Promotion>> getPromotion(
    String accessCode,
    String token,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse(TAppRoutes.getPromotionRoute),
            body: jsonEncode({'accessCode': accessCode}),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final Map<String, dynamic> promotion = jsonDecode(res.body);
        return Result.ok(Promotion.fromJson(promotion));
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 404) {
        return Result.error(PromotionNotFoundException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else {
        return Result.error(
          ServerException("Failed with status : ${res.statusCode}"),
        );
      }
    } on SocketException {
      return Result.error(NoInternetException());
    } on FormatException {
      return Result.error(DataParsingException());
    } on TimeoutException {
      return Result.error(NetworkTimeoutException());
    } on Exception catch (e) {
      return Result.error(UnknownServiceException(e.toString()));
    } catch (e, stacktrace) {
      return Result.error(UnknownServiceException(e.toString()));
    }
  }

  Future<Result<Promotion>> createPromotion(
    String name,
    StudyField field,
    PromotionLevel level,
    String accessCode,
    String token,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse(TAppRoutes.createPromotionRoute),
            body: jsonEncode({
              'name': name,
              'field': field.displayName,
              'promotionLevel': level.name,
              'accessCode': accessCode,
            }),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if ((res.statusCode == 200 || res.statusCode == 201) &&
          res.body.isNotEmpty) {
        final promotion = jsonDecode(res.body);
        return Result.ok(Promotion.fromJson(promotion));
      } else if (res.statusCode == 400) {
        return Result.error(BadRequestException());
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 409) {
        return Result.error(PromotionAlreadyExistsException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else if (res.statusCode >= 500) {
        return Result.error(
          ServerException("Server error with status code : ${res.statusCode}"),
        );
      } else {
        return Result.error(CouldNotCreatePromotionException());
      }
    } on SocketException {
      return Result.error(NoInternetException());
    } on TimeoutException {
      return Result.error(NetworkTimeoutException());
    } on FormatException {
      return Result.error(DataParsingException());
    } on Exception catch (e) {
      return Result.error(UnknownServiceException(e.toString()));
    } catch (e, stacktrace) {
      return Result.error(UnknownServiceException(e.toString()));
    }
  }

  Future<Result<void>> deletePromotion(String accessCode, String token) async {
    try {
      final res = await http
          .delete(
            Uri.parse(TAppRoutes.deletePromotionRoute),
            body: jsonEncode(accessCode),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 || res.statusCode == 204) {
        return Result.ok(null);
      } else if (res.statusCode == 404) {
        return Result.error(PromotionNotFoundException());
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else if (res.statusCode >= 500) {
        return Result.error(
          ServerException("Server error with status code : ${res.statusCode}"),
        );
      } else {
        return Result.error(CouldNotDeletePromotionException());
      }
    } on SocketException {
      return Result.error(NoInternetException());
    } on TimeoutException {
      return Result.error(NetworkTimeoutException());
    } on Exception catch (e) {
      return Result.error(UnknownServiceException(e.toString()));
    } catch (e, stacktrace) {
      return Result.error(UnknownServiceException(e.toString()));
    }
  }
}
