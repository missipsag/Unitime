import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:unitime/core/constants/app_routes.dart';
import 'package:unitime/core/utils/result.dart';
import 'package:unitime/data/uni_appointment.dart';

class UniAppointmentService {
  static final UniAppointmentService _shared =
      UniAppointmentService._sharedInstance();

  UniAppointmentService._sharedInstance();

  factory UniAppointmentService() => _shared;

  Future<Result<List<UniAppointment>>> get getAppointments async {
    try {
      final res = await http.get(
        Uri.parse("http://localhost:8080/api/appointments/get"),
      );

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        List<dynamic> allAppointments = jsonDecode(res.body);
        final appointments = allAppointments
            .map((app) => UniAppointment.fromJson(app))
            .toList();
        return Result.ok(appointments);
      } else {
        return Result.error(Exception("Failed to fetch appointments"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> createAppointment(UniAppointment appointment) async {
    try {
      final res = await http.post(
        Uri.parse("http://localhost:8080/api/appointments/create"),
        body: appointment,
      );

      if (res.statusCode == 201 && res.body.isNotEmpty) {
        return Result.ok(null);
      } else {
        return Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deleteAppointment(int appointmentId) async {
    try {
      final res = await http.delete(
        Uri.parse("http://localhost:8080/api/appointments/delete"),
        body: appointmentId,
      );

      if (res.statusCode == 200) {
        return Result.ok(null);
      } else {
        return Result.error(Exception("Invalid response."));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<UniAppointment>>> getCurrentAppointments(
    String token,
  ) async {
    try {
      final res = await http.post(
        Uri.parse(TAppRoutes.getCurrentAppointmentsRoute),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200 && res.body.isNotEmpty) {
        List<dynamic> appointmentsJson = jsonDecode(res.body);

        final currAppointments = appointmentsJson
            .map((app) => UniAppointment.fromJson(app))
            .toList();

        return Result.ok(currAppointments);
      } else {
        return Result.error(Exception("Invalid response."));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<UniAppointment>>> getUpcomingSpecialEvents(
    String token,
  ) async {
    try {
      final res = await http.post(
        Uri.parse(TAppRoutes.getUpcomingSpecialEventsRoute),
        headers: {'Authorization ': 'Bearer $token'},
      );

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        List<dynamic> specialEventsJson = jsonDecode(res.body);
        final specialEvents = specialEventsJson
            .map((app) => UniAppointment.fromJson(app))
            .toList();
        return Result.ok(specialEvents);
      } else {
        return Result.error(Exception("Invalid response."));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
