import 'package:unitime/data/uni_appointment.dart';
import 'package:unitime/service/uni_appointment_service.dart';

class UniAppointmentRepository {
  static final UniAppointmentRepository _shared =
      UniAppointmentRepository.sharedInstance();

  UniAppointmentRepository.sharedInstance();

  factory UniAppointmentRepository() => _shared;

  final UniAppointmentService uniAppointmentService = UniAppointmentService();

  Future<List<UniAppointment>> getAllAppointments() async {
    return await uniAppointmentService.getAppointments;
  }
}
