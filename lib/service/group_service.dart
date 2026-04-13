import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:unitime/core/constants/app_routes.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/group.dart';

class GroupService {
  static final GroupService _shared = GroupService._sharedInstance();

  GroupService._sharedInstance();

  factory GroupService() => _shared;

  Future<Result<Group>> createGroup(
    String groupName,
    String accessCode,
    int promotionId,
    String token,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse(TAppRoutes.createGroupRoute),
            body: jsonEncode({
              'name': groupName,
              'accessCode': accessCode,
              'promotionId': promotionId,
            }),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if ((res.statusCode == 200 || res.statusCode == 201) &&
          res.body.isNotEmpty) {
        final Map<String, dynamic> group = jsonDecode(res.body);
        return Result.ok(Group.fromJson(group));
      } else if (res.statusCode == 400) {
        return Result.error(BadRequestException());
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 409) {
        return Result.error(GroupAlreadyExistsException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else if (res.statusCode >= 500) {
        return Result.error(
          ServerException("Server error with status code : ${res.statusCode}"),
        );
      } else {
        return Result.error(CouldNotCreateGroupException());
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

  Future<Result<Group>> getGroup(String accessCode, String token) async {
    try {
      final res = await http
          .post(
            Uri.parse(TAppRoutes.getGroupRoute),
            body: jsonEncode({'accessCode': accessCode}),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final Map<String, dynamic> group = jsonDecode(res.body);
        return Result.ok(Group.fromJson(group));
      } else if (res.statusCode == 400) {
        return Result.error(BadRequestException());
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 404) {
        return Result.error(GroupNotFoundException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else {
        return Result.error(
          ServerException("Server error with status code : ${res.statusCode}"),
        );
      }
    } on SocketException {
      return Result.error(NoInternetException());
    } on FormatException {
      return Result.error(DataParsingException());
    } on TimeoutException {
      return Result.error(RateLimitException());
    } on Exception catch (e) {
      return Result.error(UnknownServiceException(e.toString()));
      } catch (e, stacktrace) {
      return Result.error(UnknownServiceException(e.toString()));
    }
  }
}
