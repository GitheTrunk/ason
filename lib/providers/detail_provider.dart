import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/emergency_service.dart';
import 'emergency_provider.dart';

final serviceByIdProvider = FutureProvider.family<EmergencyService?, String>((
  ref,
  id,
) async {
  final services = await ref.watch(servicesProvider.future);

  try {
    return services.firstWhere((service) => service.id == id);
  } catch (_) {
    return null;
  }
});
