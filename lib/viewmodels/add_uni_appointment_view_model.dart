import 'package:flutter/material.dart';
import 'package:unitime/core/utils/command.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/uni_appointment.dart';
import 'package:unitime/repository/uni_appointment_repository.dart';

class AddUniAppointmentViewModel extends ChangeNotifier {
  AddUniAppointmentViewModel({
    required UniAppointmentRepository appointmentRepository,
  }) : _appointmentRepository = appointmentRepository {
    createAppointment = Command1(_createAppointment);
  }

  final UniAppointmentRepository _appointmentRepository;

  late final Command1<UniAppointment, Map<String, dynamic>> createAppointment;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<Result<UniAppointment>> _createAppointment(
    Map<String, dynamic> appointmentData,
  ) async {
    _errorMessage = null;

    try {
      final appointment = UniAppointment.fromJson(appointmentData);

      final res = await _appointmentRepository.createAppointment(appointment);

      switch (res) {
        case Ok<UniAppointment>():
          return Result.ok(res.value);

        case Error<UniAppointment>():
          _errorMessage = _handleError(res.error);
          return Result.error(res.error);
      }
    } on Exception catch (e) {
      _errorMessage = "Something went wrong. Please try again later.";

      return Result.error(e);
    }
  }

  String _handleError(Exception e) {
    if (e is NoInternetException) {
      return "Please check your internet connection and try again.";
    }
    if (e is UnauthorizedException ||
        e is UserNotAuthenticatedAuthException ||
        e is NoValueAssociatedWithKeyException) {
      return "Your session expired. Please log in again.";
    }
    if (e is RateLimitException) {
      return "Seems like you exceeded the rate limit. Try again in a moment.";
    }
    if (e is DataParsingException) {
      return "Seems like the appointment data you provided is invalid.";
    }
    if (e is NetworkTimeoutException) {
      return "We failed to create the appointment in time. Please try again later.";
    }
    if (e is AppointmentAlreadyExistsException) {
      return "An appointment with the same details already exists. Please try again with different details.";
    }
    if (e is BadRequestException) {
      return "The appointment data is invalid. Please check your input.";
    }
    if (e is CouldNotCreateAppointmentException) {
      return "Could not create the appointment. Please try again later.";
    } else {
      return "Could not create the appointment. Please try again later.";
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    createAppointment.dispose();
    super.dispose();
  }
}
