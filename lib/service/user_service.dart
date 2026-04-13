import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:unitime/core/constants/app_routes.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/user.dart';

class UserService {
  UserService();

  Future<Result<User>> getUser(String token) async {
    try {
      final res = await http
          .get(
            Uri.parse(TAppRoutes.getUserRoute),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final Map<String, dynamic> currUser = jsonDecode(res.body);
        return Result.ok(User.fromJson(currUser));
      } else if (res.statusCode == 400) {
        return Result.error(BadRequestException());
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 404) {
        return Result.error(UserNotFoundException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else {
        return Result.error(
          ServerException("Failed with status code : ${res.statusCode}"),
        );
      }
    } on SocketException {
      return Result.error(NoInternetException());
    } on TimeoutException {
      return Result.error(NetworkTimeoutException());
    } on FormatException catch (e) {
      return Result.error(DataParsingException());
    } on Exception catch (e) {
      return Result.error(UnknownServiceException(e.toString()));
    } catch (e, stacktrace) {
      return Result.error(UnknownServiceException(e.toString()));
    }
  }

  Future<Result<User>> updateUser(User user, String token) async {
    try {
      final res = await http
          .put(
            Uri.parse(TAppRoutes.updateUserRoute),
            body: jsonEncode(user),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 || res.body.isNotEmpty) {
        final Map<String, dynamic> editedUser = jsonDecode(res.body);

        return Result.ok(User.fromJson(editedUser));
      }
      if (res.statusCode == 400) {
        return Result.error(BadRequestException());
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 409) {
        return Result.error(UserAlreadyExistsException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else if (res.statusCode >= 500) {
        return Result.error(
          ServerException("Server error with status code : ${res.statusCode}"),
        );
      } else {
        return Result.error(CouldNotUpdateUserException());
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

  Future<Result<void>> joinGroup(int groupId, String token) async {
    try {
      final res = await http
          .post(
            Uri.parse(TAppRoutes.joinGroupRoute),
            body: jsonEncode(groupId),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 || res.body.isNotEmpty) {
        return Result.ok(null);
      }
      if (res.statusCode == 400) {
        return Result.error(BadRequestException());
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 409) {
        return Result.error(UserAlreadyExistsException());
      } else if (res.statusCode == 404) {
        return Result.error(GroupNotFoundException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else if (res.statusCode >= 500) {
        return Result.error(
          ServerException("Server error with status code : ${res.statusCode}"),
        );
      } else {
        return Result.error(CouldNotUpdateUserException());
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

  Future<Result<void>> joinPromotion(int promotionId, String token) async {
    try {
      final res = await http
          .post(
            Uri.parse(TAppRoutes.joinPromotionRoute),
            body: jsonEncode(promotionId),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 || res.body.isNotEmpty) {
        return Result.ok(null);
      }
      if (res.statusCode == 400) {
        return Result.error(BadRequestException());
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 409) {
        return Result.error(UserAlreadyExistsException());
      } else if (res.statusCode == 404) {
        return Result.error(PromotionNotFoundException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else if (res.statusCode >= 500) {
        return Result.error(
          ServerException("Server error with status code : ${res.statusCode}"),
        );
      } else {
        return Result.error(CouldNotUpdateUserException());
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
}
