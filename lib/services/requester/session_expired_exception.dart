import 'package:hw_dashboard_core/hw_dashboard_core.dart';

class SessionExpiredException extends AppException {
  SessionExpiredException() : super('Session expired, please log in again.');
}
