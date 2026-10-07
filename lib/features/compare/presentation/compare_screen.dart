import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../shared/providers/app_state_providers.dart';

class CompareScreen extends ConsumerWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareList = ref.watch(compareProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Comparison"),
        actions: [
          if (compareList.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(compareProvider.notifier).clearCompare(),
              child: const Text("Clear All"),
            ),
        ],
      ),
      body: compareList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.compare_arrows_rounded,
                      size: 64, color: AppColors.darkTextTertiary),
                  const SizedBox(height: 16),
                  const Text(
                    "No Products in Compare Matrix",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap the compare icon on product pages to compare specs side-by-side",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.darkTextTertiary),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  // Product Cards Row
                  Row(
                    children: compareList.map((p) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: GlassCard(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Image.network(p.images.first, height: 100, fit: BoxFit.cover),
                                const SizedBox(height: 8),
                                Text(
                                  p.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  CurrencyFormatter.format(p.price),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary),
                                ),
                                const SizedBox(height: 8),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 16),
                                  onPressed: () =>
                                      ref.read(compareProvider.notifier).toggleCompare(p),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Comparison Matrix Table
                  const Text(
                    "SPECIFICATIONS MATRIX",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildRow("Brand", compareList.map((p) => p.brand).toList()),
                        _buildRow("Rating", compareList.map((p) => "★ ${p.rating}").toList()),
                        _buildRow("Category", compareList.map((p) => p.category).toList()),
                        _buildRow("Stock", compareList.map((p) => "${p.stockCount} left").toList()),
                        _buildRow("Delivery", compareList.map((p) => "${p.deliveryDays} Days").toList()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRow(String label, List<String> values) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.darkTextTertiary)),
          const SizedBox(height: 6),
          Row(
            children: values
                .map((v) => Expanded(
                      child: Text(
                        v,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
