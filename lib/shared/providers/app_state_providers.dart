import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_database.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/cart_item_model.dart';
import '../models/wishlist_model.dart';
import '../models/order_model.dart';
import '../models/coupon_model.dart';
import '../models/user_model.dart';

// --- CATEGORIES ---
final categoriesProvider = Provider<List<CategoryModel>>((ref) {
  return MockDatabase.categories;
});

// --- USER PROVIDER ---
class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(MockDatabase.defaultUser);

  void addAddress(AddressModel newAddr) {
    final updatedList = [...state.addresses, newAddr];
    state = UserModel(
      id: state.id,
      name: state.name,
      email: state.email,
      phone: state.phone,
      avatarUrl: state.avatarUrl,
      flexCoins: state.flexCoins,
      membershipTier: state.membershipTier,
      addresses: updatedList,
    );
  }

  void setDefaultAddress(String addressId) {
    final updated = state.addresses.map((a) {
      return AddressModel(
        id: a.id,
        label: a.label,
        recipientName: a.recipientName,
        phone: a.phone,
        streetAddress: a.streetAddress,
        city: a.city,
        state: a.state,
        pincode: a.pincode,
        isDefault: a.id == addressId,
      );
    }).toList();

    state = UserModel(
      id: state.id,
      name: state.name,
      email: state.email,
      phone: state.phone,
      avatarUrl: state.avatarUrl,
      flexCoins: state.flexCoins,
      membershipTier: state.membershipTier,
      addresses: updated,
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  return UserNotifier();
});

// --- CART PROVIDER ---
class CartState {
  final List<CartItemModel> items;
  final CouponModel? appliedCoupon;

  const CartState({
    required this.items,
    this.appliedCoupon,
  });

  List<CartItemModel> get activeItems =>
      items.where((i) => !i.isSavedForLater).toList();

  List<CartItemModel> get savedItems =>
      items.where((i) => i.isSavedForLater).toList();

  double get subtotal =>
      activeItems.fold(0.0, (sum, i) => sum + i.totalPrice);

  double get discountSavings =>
      appliedCoupon?.calculateSavings(subtotal) ?? 0.0;

  double get deliveryFee => (subtotal > 999.0 || subtotal == 0) ? 0.0 : 99.0;

  double get gstTax => (subtotal - discountSavings) * 0.18; // 18% GST

  double get grandTotal {
    if (activeItems.isEmpty) return 0.0;
    return (subtotal - discountSavings) + deliveryFee + gstTax;
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier()
      : super(CartState(items: [
          CartItemModel(
            product: MockDatabase.products[0],
            selectedVariant: MockDatabase.products[0].variants[0],
            quantity: 1,
          ),
        ]));

  void addToCart(ProductModel product, {ProductVariant? variant}) {
    final existingIndex = state.items.indexWhere(
        (i) => i.product.id == product.id && i.selectedVariant?.id == variant?.id);

    if (existingIndex >= 0) {
      final updated = [...state.items];
      updated[existingIndex].quantity += 1;
      state = CartState(items: updated, appliedCoupon: state.appliedCoupon);
    } else {
      state = CartState(
        items: [
          ...state.items,
          CartItemModel(product: product, selectedVariant: variant, quantity: 1)
        ],
        appliedCoupon: state.appliedCoupon,
      );
    }
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final updated = state.items.map((item) {
      if (item.product.id == productId) {
        return CartItemModel(
          product: item.product,
          selectedVariant: item.selectedVariant,
          quantity: quantity,
          isSavedForLater: item.isSavedForLater,
        );
      }
      return item;
    }).toList();

    state = CartState(items: updated, appliedCoupon: state.appliedCoupon);
  }

  void removeFromCart(String productId) {
    final updated =
        state.items.where((item) => item.product.id != productId).toList();
    state = CartState(items: updated, appliedCoupon: state.appliedCoupon);
  }

  void toggleSaveForLater(String productId) {
    final updated = state.items.map((item) {
      if (item.product.id == productId) {
        return CartItemModel(
          product: item.product,
          selectedVariant: item.selectedVariant,
          quantity: item.quantity,
          isSavedForLater: !item.isSavedForLater,
        );
      }
      return item;
    }).toList();

    state = CartState(items: updated, appliedCoupon: state.appliedCoupon);
  }

  void applyCoupon(CouponModel coupon) {
    state = CartState(items: state.items, appliedCoupon: coupon);
  }

  void removeCoupon() {
    state = CartState(items: state.items, appliedCoupon: null);
  }

  void clearCart() {
    state = const CartState(items: []);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// --- WISHLIST PROVIDER ---
class WishlistNotifier extends StateNotifier<List<WishlistItemModel>> {
  WishlistNotifier() : super([]);

  void toggleWishlist(ProductModel product, {String collection = "Wishlist"}) {
    final exists = state.any((i) => i.product.id == product.id);
    if (exists) {
      state = state.where((i) => i.product.id != product.id).toList();
    } else {
      state = [
        ...state,
        WishlistItemModel(
          product: product,
          collectionName: collection,
          addedAt: DateTime.now(),
          priceWhenAdded: product.price,
        ),
      ];
    }
  }

  bool isWishlisted(String productId) {
    return state.any((i) => i.product.id == productId);
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<WishlistItemModel>>((ref) {
  return WishlistNotifier();
});

// --- COMPARE PROVIDER ---
class CompareNotifier extends StateNotifier<List<ProductModel>> {
  CompareNotifier() : super([]);

  void toggleCompare(ProductModel product) {
    if (state.any((p) => p.id == product.id)) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      if (state.length >= 3) {
        // Max 3 comparison limit
        state = [...state.sublist(1), product];
      } else {
        state = [...state, product];
      }
    }
  }

  void clearCompare() {
    state = [];
  }
}

final compareProvider =
    StateNotifierProvider<CompareNotifier, List<ProductModel>>((ref) {
  return CompareNotifier();
});

// --- ORDERS PROVIDER ---
class OrdersNotifier extends StateNotifier<List<OrderModel>> {
  OrdersNotifier() : super(MockDatabase.sampleOrders);

  void addOrder(OrderModel newOrder) {
    state = [newOrder, ...state];
  }
}

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, List<OrderModel>>((ref) {
  return OrdersNotifier();
});

// --- SEARCH & FILTERING PROVIDERS ---
final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final priceFilterRangeProvider = StateProvider<RangeValues>((ref) => const RangeValues(0, 200000));

enum SortOption { relevance, priceLowHigh, priceHighLow, rating, discount }

final selectedSortOptionProvider = StateProvider<SortOption>((ref) => SortOption.relevance);

final filteredProductsProvider = Provider<List<ProductModel>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final priceRange = ref.watch(priceFilterRangeProvider);
  final sortOption = ref.watch(selectedSortOptionProvider);

  List<ProductModel> result = MockDatabase.products.where((p) {
    // Search query filter
    if (query.isNotEmpty) {
      final matchName = p.name.toLowerCase().contains(query);
      final matchBrand = p.brand.toLowerCase().contains(query);
      final matchCategory = p.category.toLowerCase().contains(query);
      final matchTags = p.tags.any((t) => t.toLowerCase().contains(query));
      if (!matchName && !matchBrand && !matchCategory && !matchTags) {
        return false;
      }
    }

    // Category filter
    if (selectedCategory != null && selectedCategory.isNotEmpty) {
      if (p.category.toLowerCase() != selectedCategory.toLowerCase()) {
        return false;
      }
    }

    // Price range filter
    if (p.price < priceRange.start || p.price > priceRange.end) {
      return false;
    }

    return true;
  }).toList();

  // Sorting logic
  switch (sortOption) {
    case SortOption.priceLowHigh:
      result.sort((a, b) => a.price.compareTo(b.price));
      break;
    case SortOption.priceHighLow:
      result.sort((a, b) => b.price.compareTo(a.price));
      break;
    case SortOption.rating:
      result.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    case SortOption.discount:
      result.sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
      break;
    case SortOption.relevance:
      break;
  }

  return result;
});
