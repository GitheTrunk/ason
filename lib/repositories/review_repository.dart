import '../models/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getReviews(String serviceId);

  Future<Review> createReview(Review review);
}
