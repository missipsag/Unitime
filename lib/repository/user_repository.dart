import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/user.dart';
import 'package:unitime/service/user_service.dart';

class UserRepository {
  static final UserRepository _shared = UserRepository.sharedInstance();

  UserRepository.sharedInstance();

  factory UserRepository() => _shared;
  final UserService _userService = UserService();

  Future<Result<User>> getUser(String token) async {
    return await _userService.getUser(token);
  }

  Future<Result<User>> updateUser(User user, String token) async {
    return await _userService.updateUser(user, token);
  }
}
