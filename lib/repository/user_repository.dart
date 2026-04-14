import 'package:unitime/core/constants/env_config.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/user.dart';
import 'package:unitime/service/storage_service.dart';
import 'package:unitime/service/user_service.dart';

class UserRepository {
  static final UserRepository _shared = UserRepository.sharedInstance();

  UserRepository.sharedInstance();

  factory UserRepository() => _shared;
  final UserService _userService = UserService();
  final StorageService _storageService = StorageService();
  final String _authTokenKey = EnvConfig.authTokenKey;

  Future<Result<User>> getUser() async {
    try {
      final token = await _storageService.read(_authTokenKey);
      switch (token) {
        case Ok<String>():
          final user = await _userService.getUser(token.value);
          return user;
        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {

      return Result.error(e);
    }
  }

  Future<Result<User>> updateUser(User user) async {
    try {
      final token = await _storageService.read(_authTokenKey);
      switch (token) {
        case Ok<String>():
          return await _userService.updateUser(user, token.value);

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> joinGroup(int groupId) async {
    try {
      final token = await _storageService.read(_authTokenKey);
      switch (token) {
        case Ok<String>():
          return await _userService.joinGroup(groupId, token.value);

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> joinPromotion(int promotionId) async {
    try {
      final token = await _storageService.read(_authTokenKey);
      switch (token) {
        case Ok<String>():
          return await _userService.joinPromotion(promotionId, token.value);

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
