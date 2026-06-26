import '../models/emergency_service.dart';

abstract class EmergencyRepository {
  Future<List<EmergencyService>> getServices();

  Future<EmergencyService> getService(String id);
}
