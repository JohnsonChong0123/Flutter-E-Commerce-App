import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/common/widgets/loader.dart';
import '../../core/themes/app_colors.dart';
import '../../domain/entity/product/product_summary_entity.dart';
import '../cubits/product/product_cubit.dart';
import '../cubits/search/search_cubit.dart';
import '../widgets/product_card.dart';
import 'package:flutter/widget_previews.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: ClipRect(
          child: AppBar(
            backgroundColor: Colors.white.withValues(alpha: 0.8),
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.grey.shade600,
              onPressed: () {},
            ),
            title: Text(
              'ATELIER',
              style: textTheme.titleMedium?.copyWith(
                letterSpacing: 4.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                color: Colors.grey.shade600,
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 10,
                  ),
                  child: BlocBuilder<SearchCubit, String>(
                    builder: (context, state) {
                      return SearchBar(
                        textStyle: WidgetStatePropertyAll(
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                        elevation: const WidgetStatePropertyAll(3.0),
                        hintText: "Search",
                        hintStyle: WidgetStatePropertyAll(
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        leading: const Icon(
                          Icons.search,
                          color: AppColor.secondary,
                        ),
                        onChanged: (val) {
                          context.read<SearchCubit>().search(val);
                        },
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                _buildCategoryChip('All Objects', true, colorScheme, textTheme),
                const SizedBox(width: 12),
                _buildCategoryChip('Apparel', false, colorScheme, textTheme),
                const SizedBox(width: 12),
                _buildCategoryChip(
                  'Accessories',
                  false,
                  colorScheme,
                  textTheme,
                ),
                const SizedBox(width: 12),
                _buildCategoryChip('Home Decor', false, colorScheme, textTheme),
                const SizedBox(width: 12),
                _buildCategoryChip('Wellness', false, colorScheme, textTheme),
                const SizedBox(width: 12),
                _buildCategoryChip(
                  'Limited Edition',
                  false,
                  colorScheme,
                  textTheme,
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '248 ITEMS',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 10,
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.tune,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'FILTER',
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Row(
                        children: [
                          Text(
                            'SORT BY',
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.expand_more,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
            ],
          ),

          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Loader();
              } else if (state is ProductLoaded) {
                return BlocBuilder<SearchCubit, String>(
                  builder: (context, searchQuery) {
                    final filteredProducts = state.products
                        .where(
                          (product) => product.name.toUpperCase().startsWith(
                            searchQuery.toUpperCase(),
                          ),
                        )
                        .toList();
                    if (filteredProducts.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }
                    return Expanded(
                      child: ProductGrid(filteredProducts: filteredProducts),
                    );
                  },
                );
              } else if (state is ProductFailure) {
                return Center(child: Text(state.message));
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    String text,
    bool isSelected,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primary
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: textTheme.labelMedium?.copyWith(
          color: isSelected
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}

class ProductGrid extends StatefulWidget {
  final List<ProductSummaryEntity> filteredProducts;

  const ProductGrid({required this.filteredProducts, super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.read<ProductCubit>().loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8.0),
          itemCount: widget.filteredProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final product = widget.filteredProducts[index];
            return ProductCard(product: product);
          },
        ),
      ),
    );
  }
}

// Small fix: avoid analyzer complaining about unused import when preview isn't used
// You can open `ProductSearchScreenPreview()` in your IDE or run it directly when editing this file.
// Quick preview runner for HomeScreenPreview.
// Run this file in your IDE (Run > Run 'home_screen_preview.dart') to see the
// preview in an emulator or device. This keeps the preview code out of the
// production app's main entrypoint.

// Annotated entry for IDE Widget Preview (Android Studio / VS Code Flutter preview)
@Preview(name: 'ProductSearch - Light', size: Size(1000, 800))
Widget productSearchWidgetPreview() => const ProductSearchScreenPreview();

void main() {
  runApp(const ProductSearchScreenPreview());
}

// Widget preview helpers (safe to include in lib; no runtime side-effects)
class ProductSearchScreenPreview extends StatelessWidget {
  const ProductSearchScreenPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final products = _mockProducts();
    final theme = ThemeData.light();
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: ClipRect(
            child: AppBar(
              backgroundColor: Colors.white.withValues(alpha: 0.8),
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                color: Colors.grey.shade600,
                onPressed: () {},
              ),
              title: Text(
                'ATELIER',
                style: textTheme.titleMedium?.copyWith(
                  letterSpacing: 4.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  color: Colors.grey.shade600,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: SearchBar(
                textStyle: WidgetStatePropertyAll(
                  theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                textInputAction: TextInputAction.search,
                elevation: const WidgetStatePropertyAll(3.0),
                hintText: 'Search',
                hintStyle: WidgetStatePropertyAll(
                  theme.textTheme.titleMedium?.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                leading: const Icon(Icons.search, color: AppColor.secondary),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _buildCategoryChipPreview(
                    'All Objects',
                    true,
                    colorScheme,
                    textTheme,
                  ),
                  const SizedBox(width: 12),
                  _buildCategoryChipPreview(
                    'Apparel',
                    false,
                    colorScheme,
                    textTheme,
                  ),
                  const SizedBox(width: 12),
                  _buildCategoryChipPreview(
                    'Accessories',
                    false,
                    colorScheme,
                    textTheme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${products.length} ITEMS',
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                  ),
                ],
              ),
            ),
            Expanded(child: ProductGrid(filteredProducts: products)),
          ],
        ),
      ),
    );
  }
}

Widget _buildCategoryChipPreview(
  String text,
  bool isSelected,
  ColorScheme colorScheme,
  TextTheme textTheme,
) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: textTheme.labelMedium?.copyWith(
        color: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      ),
    ),
  );
}

List<ProductSummaryEntity> _mockProducts() {
  return List<ProductSummaryEntity>.generate(
    6,
    (i) => ProductSummaryEntity(
      id: 'p\$i',
      name: 'Sample Product #\$i',
      initialPrice: 29.99 + i * 5,
      finalPrice: (i % 2 == 0) ? (24.99 + i * 4) : (29.99 + i * 5),
      imageUrl: '', // empty will cause ProductCard to show placeholder
    ),
  );
}
