import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/first_aid_guide.dart';
import '../repositories/first_aid_repository.dart';

final firstAidRepositoryProvider = Provider<FirstAidRepository>((ref) {
  return FirstAidRepository();
});

final firstAidProvider = FutureProvider<List<FirstAidGuide>>((ref) async {
  final repository = ref.watch(firstAidRepositoryProvider);

  return repository.getGuides();
});
