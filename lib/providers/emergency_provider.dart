import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repository_providers.dart';

final servicesProvider = FutureProvider((ref) async {
  final repository = ref.watch(emergencyRepositoryProvider);

  return repository.getServices();
});
