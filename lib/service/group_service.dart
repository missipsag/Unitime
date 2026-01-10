import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/group.dart';

class GroupService {
  static final GroupService _shared = GroupService._sharedInstance();

  GroupService._sharedInstance();

  factory GroupService() => _shared;

  Future<Result<Group>> createGroup(Group group) async {
    try {
      final res = await http.post(
        Uri.parse("http://localhost:8080/api/groups/create"),
        body: jsonEncode(group),
      );

      if (res.statusCode == 200) {
        final group = jsonDecode(res.body);
        return Result.ok(Group.fromJson(group));
      } else {
        return Result.error(Exception("Failed to create group."));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Group>> getGroup(String accessCode) async {
    try {
      final res = await http.post(
        Uri.parse("http://localhost:8080/api/groups/"),
        body: jsonEncode(accessCode),
      );

      if (res.statusCode == 200) {
        final group = jsonDecode(res.body);
        return Result.ok(Group.fromJson(group));
      } else {
        return Result.error(Exception("Failed to get group"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
