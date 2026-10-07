import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/accessibility/accessibility_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../shared/providers/app_state_providers.dart';
import '../../orders/presentation/orders_screen.dart';
import '../../rewards/presentation/rewards_screen.dart';
import '../../wishlist/presentation/wishlist_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userProvider);
    final accessState = ref.watch(accessibilityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account & Settings"),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Profile Card Header
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.darkTextTertiary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppGradients.heroGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.membershipTier,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Links Grid
            Row(
              children: [
                _quickTile(context, Icons.inventory_2_outlined, "Orders", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersScreen(),
                    ),
                  );
                }),
                const SizedBox(width: 12),
                _quickTile(
                  context,
                  Icons.favorite_border_rounded,
                  "Wishlist",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WishlistScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _quickTile(
                  context,
                  Icons.monetization_on_outlined,
                  "Rewards",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RewardsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ACCESSIBILITY & SETTINGS ACCORDION
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ACCESSIBILITY & DISPLAY",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const Divider(height: 20),
                    SwitchListTile(
                      title: const Text(
                        "Reduce Motion",
                        style: TextStyle(fontSize: 13),
                      ),
                      subtitle: const Text(
                        "Replaces complex animations with simple fades",
                        style: TextStyle(fontSize: 11),
                      ),
                      value: accessState.reducedMotion,
                      onChanged: (_) => ref
                          .read(accessibilityProvider.notifier)
                          .toggleReducedMotion(),
                    ),
                    SwitchListTile(
                      title: const Text(
                        "High Contrast Mode",
                        style: TextStyle(fontSize: 13),
                      ),
                      value: accessState.highContrast,
                      onChanged: (_) => ref
                          .read(accessibilityProvider.notifier)
                          .toggleHighContrast(),
                    ),
                    ListTile(
                      title: const Text(
                        "Language",
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: DropdownButton<String>(
                        value: AppStrings.currentLanguage,
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text("English")),
                          DropdownMenuItem(
                            value: 'hi',
                            child: Text("हिंदी (Hindi)"),
                          ),
                          DropdownMenuItem(
                            value: 'te',
                            child: Text("తెలుగు (Telugu)"),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            AppStrings.currentLanguage = val;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Saved Delivery Addresses Card
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SAVED DELIVERY ADDRESSES",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const Divider(height: 20),
                  ...user.addresses.map((a) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${a.label} — ${a.recipientName}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  a.fullAddress,
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
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _quickTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 26),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
