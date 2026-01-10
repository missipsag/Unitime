import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/user.dart';
import 'package:unitime/service/user_service.dart';

class UserRepository {
  static final UserRepository _shared = UserRepository.sharedInstance();

  UserRepository.sharedInstance();

  factory UserRepository() => _shared;
  final UserService _userService = UserService();

  Future<Result<User>> getUser() async {
    return await _userService.getUser();
  }

  Future<Result<User>> updateUser(User user) async {
    return await _userService.updateUser(user);
  }
}
