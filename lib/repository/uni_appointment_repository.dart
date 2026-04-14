import 'package:unitime/core/constants/env_config.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/uni_appointment.dart';
import 'package:unitime/service/storage_service.dart';
import 'package:unitime/service/uni_appointment_service.dart';

class UniAppointmentRepository {
  static final UniAppointmentRepository _shared =
      UniAppointmentRepository.sharedInstance();

  UniAppointmentRepository.sharedInstance();

  factory UniAppointmentRepository() => _shared;

  final UniAppointmentService _uniAppointmentService = UniAppointmentService();
  final StorageService _storageService = StorageService();
  final String _authTokenKey = EnvConfig.authTokenKey;

  Future<Result<List<UniAppointment>>> getAllAppointments() async {
    try {
      final token = await _storageService.read(_authTokenKey);
      switch (token) {
        case Ok<String>():
          return await _uniAppointmentService.getAppointments(token.value);

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<UniAppointment>>> getCurrentAppointments() async {
    try {
      final token = await _storageService.read(_authTokenKey);
      switch (token) {
        case Ok<String>():
          return await _uniAppointmentService.getCurrentAppointments(
            token.value,
          );

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<UniAppointment>>> getUpcomingSpecialEvents() async {
    try {
      final token = await _storageService.read(_authTokenKey);
      switch (token) {
        case Ok<String>():
          return await _uniAppointmentService.getUpcomingSpecialEvents(
            token.value,
          );

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<UniAppointment>> createAppointment(
    UniAppointment appointment,
  ) async {
    try {
      final token = await _storageService.read(_authTokenKey);
      switch (token) {
        case Ok<String>():
          final res = await _uniAppointmentService.createAppointment(
            appointment,
            token.value,
          );

          return res;

        case Error<String>():
          return Result.error(token.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
