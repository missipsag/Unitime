//  ======================= AUTH EXCEPTIONS =========================
class UnauthorizedException implements Exception {}

class ServerException implements Exception {
  final String error;

  ServerException(this.error);
}

class RateLimitException implements Exception {}

class NetworkTimeoutException implements Exception {}

class BadRequestException implements Exception {}

class NoInternetException implements Exception {}

class DataParsingException implements Exception {}

class UnknownServiceException implements Exception {
  final String error;

  UnknownServiceException(this.error);
}

class NoValueAssociatedWithKeyException implements Exception {
  final String error;
  NoValueAssociatedWithKeyException(this.error);
}

class UserNotAuthenticatedAuthException implements Exception {}

class WrongCredentialAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class GenericAuthException implements Exception {}

class AuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

class CouldNotLogInUserAuthException implements Exception {}

class CouldNotRegisterUserAuthException implements Exception {}

class CouldNotLogOutUserAuthException implements Exception {}

// ======================== CRUD EXCEPTIONS =========================
// appointments related exceptions
class CouldNotCreateAppointmentException implements Exception {}

class AppointmentNotFoundException implements Exception {}

class CouldNotUpdateAppointmentException implements Exception {}

class CouldNotDeleteAppointmentException implements Exception {}

class AppointmentAlreadyExistsException implements Exception {}

// group related exceptions
class CouldNotCreateGroupException implements Exception {}

class GroupNotFoundException implements Exception {}

class CouldNotUpdateGroupException implements Exception {}

class CouldNotDeleteGroupException implements Exception {}

class GroupAlreadyExistsException implements Exception {}

// promotion related exceptions
class CouldNotCreatePromotionException implements Exception {}

class PromotionNotFoundException implements Exception {}

class CouldNotUpdatePromotionException implements Exception {}

class CouldNotDeletePromotionException implements Exception {}

class PromotionAlreadyExistsException implements Exception {}

// user related expression

class CouldNotCreateUserException implements Exception {}

class UserNotFoundException implements Exception {}

class CouldNotUpdateUserException implements Exception {}

class CouldNotDeleteUserException implements Exception {}

class UserAlreadyExistsException implements Exception {}

// Jwt related Exceptions

class JwtExpiredException implements Exception {}

class CouldNotGetJWTException implements Exception {}
