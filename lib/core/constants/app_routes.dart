import 'package:flutter/foundation.dart';

class TAppRoutes {
  TAppRoutes._();

  static final String ip =kIsWeb ? "127.0.0.1".trim() : "192.168.43.4".trim();

  // TODO : delete this token. For dev purposes only
  static String get token =>
      "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJnaGVybmFvdXRtaXNzaXBzYS5wcm9AZ21haWwuY29tIiwiaWF0IjoxNzczMzQ3Mzc2LCJleHAiOjE3NzM0MzM3NzZ9.ctjNLOYMCGBpE0nJheye6GaLA1ARd-s9TOa-Llr9Ls4EDQs5oK2onxhN5D2oI7donQYCpmRPkplTEl3db7UW9w";

  // privacy and support uls
  static Uri privacyAndSupportUrl = Uri.parse(
    "https://www.freeprivacypolicy.com/live/5a89239a-0329-4b4c-aa2f-c21b8a9b8602",
  );

  // auth routes
  static String get loginRoute => "http://$ip:8080/api/auth/login";
  static String get registerRoute => "http://$ip:8080/api/auth/register";

  // group related routes
  static String get createGroupRoute => "http://$ip:8080/api/groups/create";

  static String get getGroupRoute => "http://$ip:8080/api/promotions/create";

  // promotion related routes
  static String get createPromotionRoute =>
      "http://$ip:8080/api/promotions/create";

  static String get getPromotionRoute => "http://$ip:8080/api/promotions/get";

  static String get deletePromotionRoute =>
      "http://$ip:8080/api/promotions/delete";

  // appointment related routes

  static String get getAppointmentsRoute =>
      "http://$ip:8080/api/appointments/get";

  static String get createAppointmentRoute =>
      "http://$ip:8080/api/appointments/create";

  static String get deleteAppointmentRoute =>
      "http://$ip:8080/api/appointments/delete";

  static String get getCurrentAppointmentsRoute =>
      "http://$ip:8080/api/appointments/currentAppointments";

  static String get getUpcomingSpecialEventsRoute =>
      "http://$ip:8080/api/appointments/getUpcomingSpecialEvents";

  // user related routes
  static String get getUserRoute => "http://$ip:8080/api/users/me";
  static String get updateUserRoute => "http://$ip:8080/api/users/edit";
  static String get joinGroupRoute => "http://$ip:8080/api/users/joinGroup";
  static String get joinPromotionRoute =>
      "http://$ip:8080/api/users/joinPromotion";
}
