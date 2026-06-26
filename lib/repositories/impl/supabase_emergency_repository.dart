import '../../models/emergency_service.dart';
import '../../services/supabase_service.dart';
import '../emergency_repository.dart';

class SupabaseEmergencyRepository implements EmergencyRepository {
  final SupabaseService service;

  SupabaseEmergencyRepository(this.service);

  @override
  Future<List<EmergencyService>> getServices() async {
    final data = await service.client.from('emergency_services').select();

    return data
        .map<EmergencyService>((json) => EmergencyService.fromJson(json))
        .toList();
  }

  @override
  Future<EmergencyService> getService(String id) async {
    final data = await service.client
        .from('emergency_services')
        .select()
        .eq('id', id)
        .single();

    return EmergencyService.fromJson(data);
  }
}
