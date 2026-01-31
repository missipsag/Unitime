//  ======================= AUTH EXCEPTIONS =========================
class UserNotAuthenticatedAuthException implements Exception {}

class UserNotFoundAuthException implements Exception {}

class WrongCredentialAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class GenericAuthException implements Exception {}

class AuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

class CouldNotLogInUserAuthException implements Exception {}

class CouldNotRegisterUserAuthException implements Exception {}

// ======================== CRUD EXCEPTIONS =========================
// appointments related exceptions
class CouldNotCreateAppointmentException implements Exception {}

class CouldNotGetAppointmentException implements Exception {}

class CouldNotUpdateAppointmentException implements Exception {}

class CouldNotDeleteAppointmentException implements Exception {}

// group related exceptions
class CouldNotCreateGroupException implements Exception {}

class CouldNotGetGroupException implements Exception {}

class CouldNotUpdateGroupException implements Exception {}

class CouldNotDeleteGroupException implements Exception {}

// promotion related exceptions
class CouldNotCreatePromotionException implements Exception {}

class CouldNotGetPromotionException implements Exception {}

class CouldNotUpdatePromotionException implements Exception {}

class CouldNotDeletePromotionException implements Exception {}

// user ralated expresions

class CouldNotCreateUserException implements Exception {}

class CouldNotGetUserException implements Exception {}

class CouldNotUpdateUserException implements Exception {}

class CouldNotDeleteUserException implements Exception {}

// Jwt related Exceptions

class JwtTokenExpiredException implements Exception {}
class CouldNotGetJWTToken implements Exception {}
