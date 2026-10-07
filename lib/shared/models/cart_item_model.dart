import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final ProductVariant? selectedVariant;
  int quantity;
  bool isSavedForLater;

  CartItemModel({
    required this.product,
    this.selectedVariant,
    this.quantity = 1,
    this.isSavedForLater = false,
  });

  double get unitPrice => selectedVariant?.price ?? product.price;

  double get totalPrice => unitPrice * quantity;
}
