import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/nova_button.dart';
import '../../../shared/providers/app_state_providers.dart';
import '../../products/presentation/product_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final List<String> _recentSearches = [
    "MacBook M3",
    "ANC Headphones",
    "Gaming Keyboard",
    "Streetwear Hoodie"
  ];

  @override
  void initState() {
    super.initState();
    _searchCtrl.text = ref.read(searchQueryProvider);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String val) {
    if (val.trim().isNotEmpty && !_recentSearches.contains(val.trim())) {
      setState(() {
        _recentSearches.insert(0, val.trim());
      });
    }
    ref.read(searchQueryProvider.notifier).state = val;
  }

  // Voice Search Modal Simulation
  void _openVoiceSearchModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mic_rounded, size: 48, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text(
              "Listening...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Try asking: 'Show me wireless headphones under ₹5,000'",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.darkTextTertiary),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 6,
                  height: 24.0 + (i % 3) * 12,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            NovaButton(
              label: "Cancel",
              variant: NovaButtonVariant.outline,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // Camera / Barcode Search Modal Simulation
  void _openCameraSearchModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner_rounded, size: 80, color: AppColors.secondary),
                SizedBox(height: 16),
                Text(
                  "Align barcode or product image in frame",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter Drawer / Bottom Sheet
  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final currentRange = ref.watch(priceFilterRangeProvider);
          final selectedCategory = ref.watch(selectedCategoryProvider);
          final categories = ref.watch(categoriesProvider);

          return Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter Products",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(selectedCategoryProvider.notifier).state = null;
                          ref.read(priceFilterRangeProvider.notifier).state = const RangeValues(0, 200000);
                        },
                        child: const Text("Reset All"),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Category Filter
                  const Text("Category", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((cat) {
                      final isSelected = selectedCategory == cat.name;
                      return ChoiceChip(
                        label: Text(cat.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          ref.read(selectedCategoryProvider.notifier).state =
                              selected ? cat.name : null;
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Price Range Filter
                  Text(
                    "Price Range: ${CurrencyFormatter.format(currentRange.start)} - ${CurrencyFormatter.format(currentRange.end)}",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  RangeSlider(
                    values: currentRange,
                    min: 0,
                    max: 200000,
                    divisions: 20,
                    activeColor: AppColors.primary,
                    labels: RangeLabels(
                      CurrencyFormatter.format(currentRange.start),
                      CurrencyFormatter.format(currentRange.end),
                    ),
                    onChanged: (values) {
                      ref.read(priceFilterRangeProvider.notifier).state = values;
                    },
                  ),
                  const SizedBox(height: 20),
                  NovaButton(
                    label: "Apply Filters",
                    isFullWidth: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final products = ref.watch(filteredProductsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedSort = ref.watch(selectedSortOptionProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: TextField(
            controller: _searchCtrl,
            autofocus: false,
            onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
            onSubmitted: _onSearchSubmitted,
            decoration: InputDecoration(
              hintText: "Search products, brands, tags...",
              border: InputBorder.none,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_searchCtrl.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchCtrl.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.mic_none_rounded, color: AppColors.primary),
                    onPressed: _openVoiceSearchModal,
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.secondary),
                    onPressed: _openCameraSearchModal,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter & Sort Control Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          avatar: const Icon(Icons.tune_rounded, size: 16),
                          label: Text(selectedCategory ?? "All Filters"),
                          selected: selectedCategory != null,
                          onSelected: (_) => _openFilterSheet(),
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton<SortOption>(
                          initialValue: selectedSort,
                          onSelected: (option) {
                            ref.read(selectedSortOptionProvider.notifier).state = option;
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                                value: SortOption.relevance, child: Text("Relevance")),
                            const PopupMenuItem(
                                value: SortOption.priceLowHigh,
                                child: Text("Price: Low to High")),
                            const PopupMenuItem(
                                value: SortOption.priceHighLow,
                                child: Text("Price: High to Low")),
                            const PopupMenuItem(
                                value: SortOption.rating, child: Text("Highest Rated")),
                            const PopupMenuItem(
                                value: SortOption.discount, child: Text("Biggest Discount")),
                          ],
                          child: Chip(
                            avatar: const Icon(Icons.sort_rounded, size: 16),
                            label: Text("Sort: ${selectedSort.name}"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Recent Searches Tag Cloud (shown if search empty)
          if (_searchCtrl.text.isEmpty && selectedCategory == null)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recent Searches",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _recentSearches.clear()),
                        child: const Text("Clear All",
                            style: TextStyle(fontSize: 11, color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _recentSearches.map((s) {
                      return ActionChip(
                        label: Text(s),
                        onPressed: () {
                          _searchCtrl.text = s;
                          _onSearchSubmitted(s);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Search Results Grid
          Expanded(
            child: products.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: AppColors.darkTextTertiary),
                        SizedBox(height: 12),
                        Text(
                          "No products found",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Try searching for something else or reset filters",
                          style: TextStyle(fontSize: 12, color: AppColors.darkTextTertiary),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final p = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(product: p),
                            ),
                          );
                        },
                        child: GlassCard(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                  child: Image.network(
                                    p.images.first,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(p.brand,
                                  style: const TextStyle(
                                      fontSize: 10, color: AppColors.darkTextTertiary)),
                              Text(p.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter.format(p.price),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
