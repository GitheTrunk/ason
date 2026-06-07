import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/review.dart';
import 'repository_providers.dart';

final reviewsProvider =
    FutureProvider.family<List<Review>, String>((ref, serviceId) {
  return ref.watch(reviewRepositoryProvider).getReviews(serviceId);
});
