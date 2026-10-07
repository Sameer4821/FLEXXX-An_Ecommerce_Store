import 'product_model.dart';

class WishlistItemModel {
  final ProductModel product;
  final String collectionName; // "Gaming Setup", "College Essentials", "Wishlist"
  final DateTime addedAt;
  final double priceWhenAdded;

  WishlistItemModel({
    required this.product,
    this.collectionName = "Wishlist",
    required this.addedAt,
    required this.priceWhenAdded,
  });

  bool get hasPriceDropped => product.price < priceWhenAdded;
}
