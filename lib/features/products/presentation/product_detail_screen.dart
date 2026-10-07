import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/nova_button.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/providers/app_state_providers.dart';
import '../../cart/presentation/cart_screen.dart';
import '../../compare/presentation/compare_screen.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  int _selectedVariantIndex = 0;
  final TextEditingController _pincodeCtrl = TextEditingController(
    text: '500081',
  );
  String? _pincodeResult;

  void _checkPincode() {
    if (_pincodeCtrl.text.trim().length == 6) {
      setState(() {
        _pincodeResult =
            "Express Delivery to ${_pincodeCtrl.text} by tomorrow 5 PM! (Free)";
      });
    } else {
      setState(() {
        _pincodeResult = "Enter valid 6-digit PIN code";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWishlisted = ref
        .watch(wishlistProvider.notifier)
        .isWishlisted(widget.product.id);
    final compareList = ref.watch(compareProvider);
    final isCompared = compareList.any((p) => p.id == widget.product.id);

    final selectedVariant = widget.product.variants.isNotEmpty
        ? widget.product.variants[_selectedVariantIndex]
        : null;

    final currentPrice = selectedVariant?.price ?? widget.product.price;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Top Gallery App Bar
              SliverAppBar(
                expandedHeight: 340.0,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      isWishlisted
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isWishlisted ? AppColors.accentRose : null,
                    ),
                    onPressed: () {
                      ref
                          .read(wishlistProvider.notifier)
                          .toggleWishlist(widget.product);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.compare_arrows_rounded,
                      color: isCompared ? AppColors.secondary : null,
                    ),
                    onPressed: () {
                      ref
                          .read(compareProvider.notifier)
                          .toggleCompare(widget.product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isCompared
                                ? "Removed from Compare Matrix"
                                : "Added to Compare Matrix (${compareList.length + 1}/3)",
                          ),
                          action: SnackBarAction(
                            label: "View",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CompareScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      PageView.builder(
                        itemCount: widget.product.images.length,
                        onPageChanged: (idx) =>
                            setState(() => _selectedImageIndex = idx),
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.product.images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.product.images.length,
                            (i) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _selectedImageIndex == i ? 20 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _selectedImageIndex == i
                                    ? AppColors.primary
                                    : Colors.white60,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Product Info & Price
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.product.brand.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.starRating.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: AppColors.starRating,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.product.rating} (${widget.product.reviewCount} reviews)',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Price Block
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyFormatter.format(currentPrice),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            CurrencyFormatter.format(
                              widget.product.originalPrice,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.darkTextTertiary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.discountBadge,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              CurrencyFormatter.calculateDiscount(
                                currentPrice,
                                widget.product.originalPrice,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "EMI starts at ₹${widget.product.emiStartsAt.round()}/month. No Cost EMI available.",
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Color/Size Variants Selector
                      if (widget.product.variants.isNotEmpty) ...[
                        const Text(
                          "Select Variant",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: List.generate(
                            widget.product.variants.length,
                            (index) {
                              final variant = widget.product.variants[index];
                              final isSelected = _selectedVariantIndex == index;
                              return ChoiceChip(
                                label: Text(variant.name),
                                selected: isSelected,
                                onSelected: (sel) {
                                  if (sel) {
                                    setState(
                                      () => _selectedVariantIndex = index,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // PIN code Delivery Checker
                      GlassCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Delivery & PIN Code",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _pincodeCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      hintText: "Enter 6-digit PIN code",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                NovaButton(
                                  label: "Check",
                                  height: 40,
                                  onPressed: _checkPincode,
                                ),
                              ],
                            ),
                            if (_pincodeResult != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _pincodeResult!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Specifications Table
                      const Text(
                        "Specifications",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GlassCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: widget.product.specifications.entries.map((
                            e,
                          ) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.white10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      e.key,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.darkTextTertiary,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.value,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Seller Card
                      GlassCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                widget.product.seller.avatarUrl,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product.seller.name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "★ ${widget.product.seller.rating} • ${widget.product.seller.responseRate}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.darkTextTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors.lightSurface,
                border: const Border(top: BorderSide(color: Colors.white12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: NovaButton(
                      label: "Add to Cart",
                      variant: NovaButtonVariant.outline,
                      onPressed: () {
                        ref
                            .read(cartProvider.notifier)
                            .addToCart(
                              widget.product,
                              variant: selectedVariant,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Added item to Cart!"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NovaButton(
                      label: "Buy Now",
                      onPressed: () {
                        ref
                            .read(cartProvider.notifier)
                            .addToCart(
                              widget.product,
                              variant: selectedVariant,
                            );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
