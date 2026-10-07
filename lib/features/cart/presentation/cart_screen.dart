import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/nova_button.dart';
import '../../../data/mock_database.dart';
import '../../../shared/providers/app_state_providers.dart';
import '../../checkout/presentation/checkout_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController _couponCtrl = TextEditingController();

  @override
  void dispose() {
    _couponCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        actions: [
          if (cartState.activeItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () => ref.read(cartProvider.notifier).clearCart(),
            ),
        ],
      ),
      body: cartState.activeItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 72,
                    color: AppColors.darkTextTertiary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Your Cart is Empty",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Explore latest products and add them to your cart.",
                  ),
                  const SizedBox(height: 24),
                  NovaButton(
                    label: "Start Shopping",
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cart Items List
                      ...cartState.activeItems.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: GlassCard(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.sm,
                                  ),
                                  child: Image.network(
                                    item.product.images.first,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (item.selectedVariant != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          "Variant: ${item.selectedVariant!.name}",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.darkTextTertiary,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 6),
                                      Text(
                                        CurrencyFormatter.format(
                                          item.unitPrice,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.remove_circle_outline_rounded,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            ref
                                                .read(cartProvider.notifier)
                                                .updateQuantity(
                                                  item.product.id,
                                                  item.quantity - 1,
                                                );
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            '${item.quantity}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.add_circle_outline_rounded,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            ref
                                                .read(cartProvider.notifier)
                                                .updateQuantity(
                                                  item.product.id,
                                                  item.quantity + 1,
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ref
                                            .read(cartProvider.notifier)
                                            .toggleSaveForLater(
                                              item.product.id,
                                            );
                                      },
                                      child: const Text(
                                        "Save for later",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),

                      // Coupon Box
                      GlassCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Apply Offer Coupon",
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
                                    controller: _couponCtrl,
                                    decoration: const InputDecoration(
                                      hintText: "Enter coupon (e.g. FLEXXX20)",
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                NovaButton(
                                  label: "Apply",
                                  height: 40,
                                  onPressed: () {
                                    final found = MockDatabase.coupons
                                        .firstWhere(
                                          (c) =>
                                              c.code.toLowerCase() ==
                                              _couponCtrl.text
                                                  .trim()
                                                  .toLowerCase(),
                                          orElse: () => MockDatabase.coupons[0],
                                        );
                                    ref
                                        .read(cartProvider.notifier)
                                        .applyCoupon(found);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Applied ${found.code}!"),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            if (cartState.appliedCoupon != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Coupon ${cartState.appliedCoupon!.code} Applied!",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.success,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => ref
                                        .read(cartProvider.notifier)
                                        .removeCoupon(),
                                    child: const Text(
                                      "Remove",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Bill Summary
                      GlassCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "PRICE BREAKDOWN",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const Divider(height: 20),
                            _billRow(
                              "Items Subtotal",
                              CurrencyFormatter.format(cartState.subtotal),
                            ),
                            if (cartState.discountSavings > 0)
                              _billRow(
                                "Coupon Discount",
                                "- ${CurrencyFormatter.format(cartState.discountSavings)}",
                                color: AppColors.success,
                              ),
                            _billRow(
                              "Delivery Charges",
                              cartState.deliveryFee == 0
                                  ? "FREE"
                                  : CurrencyFormatter.format(
                                      cartState.deliveryFee,
                                    ),
                            ),
                            _billRow(
                              "Estimated GST (18%)",
                              CurrencyFormatter.format(cartState.gstTax),
                            ),
                            const Divider(height: 20),
                            _billRow(
                              "Total Payable",
                              CurrencyFormatter.format(cartState.grandTotal),
                              isBold: true,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),

                // Sticky Proceed Button
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
                      border: const Border(
                        top: BorderSide(color: Colors.white12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "TOTAL AMOUNT",
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.darkTextTertiary,
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(cartState.grandTotal),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        NovaButton(
                          label: "Checkout Now →",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CheckoutScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _billRow(
    String label,
    String value, {
    Color? color,
    bool isBold = false,
    double fontSize = 13,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
