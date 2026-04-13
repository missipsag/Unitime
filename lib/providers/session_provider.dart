import 'package:flutter/material.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/group.dart';
import 'package:unitime/data/promotion.dart';
import 'package:unitime/data/user.dart';
import 'package:unitime/repository/jwt_repository.dart';
import 'package:unitime/repository/user_repository.dart';

class SessionProvider extends ChangeNotifier {
  SessionProvider({
    required JwtRepository jwtRepository,
    required UserRepository userRepository,
  }) : _jwtRepository = jwtRepository,
       _userRepository = userRepository;

  final UserRepository _userRepository;
  final JwtRepository _jwtRepository;

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  bool get hasPromotion => _currentUser?.promotion != null;

  bool get hasGroup => _currentUser?.group != null;

  Future<void> initializeSession() async {
    try {
      final res = await _jwtRepository.getToken();
      switch (res) {
        // if there is a token key value pair
        case Ok<String?>():
          // check if there is a value associated with the key
          if (res.value != null) {
            // check if the token has expired
            final isExpired = await _jwtRepository.isTokenExpired(res.value!);
            // if not expired get the user using the token
            if (isExpired is Ok<bool> && !isExpired.value) {
              // get the user;
              final userResponse = await _userRepository.getUser();

              switch (userResponse) {
                case Ok<User>():
                  _currentUser = userResponse.value;
                  _isInitializing = false;
                  notifyListeners();
                  break;

                case Error<User>():
                  _currentUser = null;
                  _isInitializing = false;
                  notifyListeners();
              }

              // the token expired, so the user has to login again
              // to get a new token.
            } else {
              _currentUser = null;
              notifyListeners();
            }

            // there is no value associated with the token value
          } else {
            _currentUser = null;
            notifyListeners();
          }
          return;
        // In the case an error happened when fetching for the token.
        // e.g : Not key associated with the token key.
        case Error<String?>():
          _isInitializing = false;
          notifyListeners();
          return;
      }

      // in case an exception happened, force the user to login again.
    } on Exception {
      _isInitializing = false;
      notifyListeners();
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  void setUserPromotion(Promotion promotion) async {
    if (_currentUser != null) {
      _currentUser?.promotion = promotion;
      notifyListeners();
    }
  }

  void setUserGroup(Group group) async {
    if (_currentUser != null) {
      _currentUser?.group = group;
      notifyListeners();
    }
  }

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> getCurrentUser() async {
    final user = await _userRepository.getUser();
    switch (user) {
      case Ok<User>():
        _currentUser = user.value;
        notifyListeners();
        return;

      case Error<User>():
        return;
    }
  }

  void logout() async {
    _currentUser = null;
    await _jwtRepository.deleteToken();
    notifyListeners();
  }
}
