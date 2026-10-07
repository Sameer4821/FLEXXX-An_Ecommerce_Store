import 'seller_model.dart';
import 'review_model.dart';

class ProductVariant {
  final String id;
  final String name; // e.g. "Space Black - 256GB" or "Navy Blue - Large"
  final String colorHex;
  final double price;
  final bool inStock;

  const ProductVariant({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.price,
    this.inStock = true,
  });
}

class ProductModel {
  final String id;
  final String name;
  final String brand;
  final String description;
  final String category;
  final String subcategory;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final bool isFlashDeal;
  final DateTime? flashEndTime;
  final bool isTrending;
  final bool isHeroFeatured;
  final Map<String, String> specifications;
  final SellerModel seller;
  final int stockCount;
  final List<ProductVariant> variants;
  final int deliveryDays;
  final double emiStartsAt;
  final List<String> bankOffers;
  final List<String> tags;
  final List<ReviewModel> reviews;

  const ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.category,
    required this.subcategory,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.images,
    this.isFlashDeal = false,
    this.flashEndTime,
    this.isTrending = false,
    this.isHeroFeatured = false,
    required this.specifications,
    required this.seller,
    required this.stockCount,
    required this.variants,
    required this.deliveryDays,
    required this.emiStartsAt,
    this.bankOffers = const [],
    this.tags = const [],
    this.reviews = const [],
  });

  double get discountPercent {
    if (originalPrice <= price) return 0;
    return (((originalPrice - price) / originalPrice) * 100);
  }

  bool get inStock => stockCount > 0;
}
