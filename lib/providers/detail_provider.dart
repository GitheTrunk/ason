import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/emergency_service.dart';
import 'repository_providers.dart';

final serviceByIdProvider = FutureProvider.family<EmergencyService?, String>((
  ref,
  id,
) async {
  try {
    final repository = ref.watch(emergencyRepositoryProvider);
    return repository.getService(id);
  } catch (_) {
    return null;
  }
});
