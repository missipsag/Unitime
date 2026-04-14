import 'package:unitime/core/constants/env_config.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/group.dart';
import 'package:unitime/service/group_service.dart';
import 'package:unitime/service/storage_service.dart';

class GroupRepository {
  static final GroupRepository _shared = GroupRepository._sharedInstance();

  GroupRepository._sharedInstance();

  factory GroupRepository() => _shared;

  final _groupService = GroupService();
  final _storageService = StorageService();
  final String _authTokenKey = EnvConfig.authTokenKey;

  Future<Result<Group>> createGroup(
    String groupName,
    String accessCode,
    int promotionId,
  ) async {
    try {
      final token = await _storageService.read(_authTokenKey);

      switch (token) {
        case Ok<String>():
          return await _groupService.createGroup(
            groupName,
            accessCode,
            promotionId,
            token.value,
          );

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Group>> getGroup(String accessCode) async {
    try {
      final token = await _storageService.read(_authTokenKey);
      switch (token) {
        case Ok<String>():
          return await _groupService.getGroup(accessCode, token.value);

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
