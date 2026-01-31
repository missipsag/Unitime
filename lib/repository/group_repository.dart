import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/group.dart';
import 'package:unitime/service/group_service.dart';

class GroupRepository {
  static final GroupRepository _shared = GroupRepository._sharedInstance();

  GroupRepository._sharedInstance();

  factory GroupRepository() => _shared;

  final _groupService = GroupService();

  Future<Result<Group>> createGroup(Group group, String token) async {
    try {
      return await _groupService.createGroup(group, token);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Group>> getGroup(String accessCode, String token) async {
    try {
      return await _groupService.getGroup(accessCode, token);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
