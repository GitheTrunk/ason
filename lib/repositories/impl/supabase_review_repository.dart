import '../../models/review.dart';
import '../../services/supabase_service.dart';
import '../review_repository.dart';

class SupabaseReviewRepository implements ReviewRepository {
  const SupabaseReviewRepository(this.service);

  final SupabaseService service;

  @override
  Future<List<Review>> getReviews(String serviceId) async {
    final data = await service.client
        .from('reviews')
        .select()
        .eq('service_id', serviceId)
        .order('created_at', ascending: false);
    return data.map<Review>((json) => Review.fromJson(json)).toList();
  }

  @override
  Future<Review> createReview(Review review) async {
    final data = await service.client
        .from('reviews')
        .insert(review.toJson())
        .select()
        .single();
    return Review.fromJson(data);
  }
}
