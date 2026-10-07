import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/nova_button.dart';
import '../../../shared/providers/app_state_providers.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flex Coins & Rewards"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                gradient: AppGradients.goldGradient,
                boxShadow: AppShadows.floating(true),
              ),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on_rounded, size: 48, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("FLEX COINS BALANCE",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8)),
                        Text(
                          '${user.flexCoins} Coins',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          "Tier: ${user.membershipTier}",
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Available Rewards Vouchers
            const Text("AVAILABLE REDEEMABLE VOUCHERS",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
            const SizedBox(height: 12),

            _voucherTile(
              "₹500 Instant Discount Voucher",
              "Costs 500 Coins • Valid on orders above ₹2,000",
              500,
            ),
            _voucherTile(
              "₹1,500 Tech Accessories Pass",
              "Costs 1,200 Coins • Valid on Audio & Wearables",
              1200,
            ),
            _voucherTile(
              "FREE Express Delivery Pass (1 Month)",
              "Costs 300 Coins • Unlimited free priority shipping",
              300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _voucherTile(String title, String desc, int coins) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.darkTextTertiary)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            NovaButton(
              label: "Redeem",
              height: 36,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
