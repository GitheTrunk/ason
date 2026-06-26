import '../models/promotion.dart';

abstract class PromotionRepository {
  Future<List<Promotion>> getPromotions();

  Future<Promotion> getPromotion(String id);
}
