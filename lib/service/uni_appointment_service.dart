import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:unitime/core/constants/app_routes.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/uni_appointment.dart';

class UniAppointmentService {
  static final UniAppointmentService _shared =
      UniAppointmentService._sharedInstance();

  UniAppointmentService._sharedInstance();

  factory UniAppointmentService() => _shared;

  Future<Result<List<UniAppointment>>> getAppointments(String token) async {
    try {
      final res = await http
          .get(
            Uri.parse(TAppRoutes.getAppointmentsRoute),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        List<dynamic> allAppointments = jsonDecode(res.body);
        final appointments = allAppointments
            .map((app) => UniAppointment.fromJson(app))
            .toList();
        return Result.ok(appointments);
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 404) {
        return Result.error(AppointmentNotFoundException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else {
        return Result.error(
          ServerException("Failed with status : ${res.statusCode}"),
        );
      }
    } on SocketException {
      return Result.error(NoInternetException());
    } on FormatException {
      return Result.error(DataParsingException());
    } on TimeoutException {
      return Result.error(NetworkTimeoutException());
    } on Exception catch (e) {
      return Result.error(UnknownServiceException(e.toString()));
    } catch (e, stacktrace) {
      return Result.error(UnknownServiceException(e.toString()));
    }
  }

  Future<Result<UniAppointment>> createAppointment(
    UniAppointment appointment,
    String token,
  ) async {
    try {

      final res = await http
          .post(
            Uri.parse(TAppRoutes.createAppointmentRoute),
            body: jsonEncode({
              'title': appointment.title,
              'location': appointment.appointmentLocation,
              'endTime': appointment.end.toIso8601String(),
              'startTime': appointment.start.toIso8601String(),
              'appointmentType': appointment.uniAppointmentType.name,
              'appointmentScope': appointment.uniAppointmentScope.name,
              'recurrenceRule': appointment.recurrence,
            }),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));
      
       if ((res.statusCode == 200 || res.statusCode == 201) &&
          res.body.isNotEmpty) {
        final Map<String, dynamic> app = jsonDecode(res.body);

        return Result.ok(UniAppointment.fromJson(app));
      } else if (res.statusCode == 400) {
        return Result.error(BadRequestException());
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 409) {
        return Result.error(PromotionAlreadyExistsException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else if (res.statusCode >= 500) {
        return Result.error(
          ServerException("Server error with status code : ${res.statusCode}"),
        );
      } else {
        return Result.error(CouldNotCreateAppointmentException());
      }
    } on SocketException {
      return Result.error(NoInternetException());
    } on TimeoutException {
      return Result.error(NetworkTimeoutException());
    } on FormatException {
      return Result.error(DataParsingException());
    } on Exception catch (e) {
      return Result.error(UnknownServiceException(e.toString()));
    } catch (e, stacktrace) {
     
      return Result.error(UnknownServiceException(e.toString()));
    }
  }

  Future<Result<void>> deleteAppointment(
    UniAppointment appointment,
    String token,
  ) async {
    try {
      final res = await http
          .delete(
            Uri.parse(TAppRoutes.deleteAppointmentRoute),
            body: jsonEncode(appointment),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 || res.statusCode == 204) {
        return Result.ok(null);
      } else if (res.statusCode == 404) {
        return Result.error(AppointmentNotFoundException());
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else if (res.statusCode >= 500) {
        return Result.error(
          ServerException("Server error with status code : ${res.statusCode}"),
        );
      } else {
        return Result.error(CouldNotDeleteAppointmentException());
      }
    } on SocketException {
      return Result.error(NoInternetException());
    } on TimeoutException {
      return Result.error(NetworkTimeoutException());
    } on Exception catch (e) {
      return Result.error(UnknownServiceException(e.toString()));
    } catch (e, stacktrace) {
      return Result.error(UnknownServiceException(e.toString()));
    }
  }

  Future<Result<List<UniAppointment>>> getCurrentAppointments(
    String token,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse(TAppRoutes.getCurrentAppointmentsRoute),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 && res.body.isNotEmpty) {
        List<dynamic> appointmentsJson = jsonDecode(res.body);

        final currAppointments = appointmentsJson
            .map((app) => UniAppointment.fromJson(app))
            .toList();

        return Result.ok(currAppointments);
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 404) {
        return Result.error(AppointmentNotFoundException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else {
        return Result.error(
          ServerException("Failed with status : ${res.statusCode}"),
        );
      }
    } on SocketException {
      return Result.error(NoInternetException());
    } on FormatException {
      return Result.error(DataParsingException());
    } on TimeoutException {
      return Result.error(NetworkTimeoutException());
    } on Exception catch (e) {
      return Result.error(UnknownServiceException(e.toString()));
    } catch (e, stacktrace) {
      return Result.error(UnknownServiceException(e.toString()));
    }
  }

  Future<Result<List<UniAppointment>>> getUpcomingSpecialEvents(
    String token,
  ) async {
    try {
      final res = await http.post(
        Uri.parse(TAppRoutes.getUpcomingSpecialEventsRoute),
        headers: {
          'Authorization ': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        List<dynamic> specialEventsJson = jsonDecode(res.body);
        final specialEvents = specialEventsJson
            .map((app) => UniAppointment.fromJson(app))
            .toList();
        return Result.ok(specialEvents);
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        return Result.error(UnauthorizedException());
      } else if (res.statusCode == 404) {
        return Result.error(AppointmentNotFoundException());
      } else if (res.statusCode == 429) {
        return Result.error(RateLimitException());
      } else {
        return Result.error(
          ServerException("Failed with status : ${res.statusCode}"),
        );
      }
    } on SocketException {
      return Result.error(NoInternetException());
    } on FormatException {
      return Result.error(DataParsingException());
    } on TimeoutException {
      return Result.error(NetworkTimeoutException());
    } on Exception catch (e) {
      return Result.error(UnknownServiceException(e.toString()));
    } catch (e, stacktrace) {
      return Result.error(UnknownServiceException(e.toString()));
    }
  }
}
