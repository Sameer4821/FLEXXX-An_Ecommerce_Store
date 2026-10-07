import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/providers/app_state_providers.dart';
import '../../products/presentation/product_detail_screen.dart';

class ExploreModeScreen extends ConsumerStatefulWidget {
  const ExploreModeScreen({super.key});

  @override
  ConsumerState<ExploreModeScreen> createState() => _ExploreModeScreenState();
}

class _ExploreModeScreenState extends ConsumerState<ExploreModeScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(filteredProductsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final isWishlisted = ref.watch(wishlistProvider.notifier).isWishlisted(product.id);

              return Stack(
                fit: StackFit.expand,
                children: [
                  // Fullscreen Image
                  Image.network(
                    product.images.first,
                    fit: BoxFit.cover,
                  ),

                  // Dark gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black87,
                          Colors.transparent,
                          Colors.black,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.4, 0.95],
                      ),
                    ),
                  ),

                  // Product Details Overlay
                  Positioned(
                    left: AppSpacing.md,
                    right: 80,
                    bottom: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.category.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          product.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              CurrencyFormatter.format(product.price),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              CurrencyFormatter.format(product.originalPrice),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Side Interactive Action Bar
                  Positioned(
                    right: 16,
                    bottom: 60,
                    child: Column(
                      children: [
                        // Wishlist Button
                        GestureDetector(
                          onTap: () {
                            ref.read(wishlistProvider.notifier).toggleWishlist(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isWishlisted
                                    ? "Removed from Wishlist"
                                    : "Saved to Wishlist!"),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white24,
                            child: Icon(
                              isWishlisted
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isWishlisted ? AppColors.accentRose : Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Add to Cart
                        GestureDetector(
                          onTap: () {
                            ref.read(cartProvider.notifier).addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Added ${product.name} to Cart!"),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary,
                            child: Icon(Icons.add_shopping_cart_rounded,
                                color: Colors.white, size: 24),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // View Full Page
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.arrow_forward_rounded,
                                color: Colors.white, size: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // Top Header Bar
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.explore_rounded, color: AppColors.secondary, size: 16),
                      SizedBox(width: 6),
                      Text(
                        "EXPLORE FEED",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 48), // Spacer
              ],
            ),
          ),
        ],
      ),
    );
  }
}
