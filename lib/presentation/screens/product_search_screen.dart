import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/common/widgets/loader.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../domain/entity/product/product_summary_entity.dart';
import '../cubits/product/product_cubit.dart';
import '../cubits/search/search_cubit.dart';
import '../widgets/product_card.dart';
import '../cubits/category/category_cubit.dart';

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
    if (context.read<CategoryCubit>().state.isEmpty) {
      context.read<CategoryCubit>().selectCategory('All Objects');
    }
  }

  Future<void> _refreshProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.read<ProductCubit>().loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              style: context.textTheme.titleMedium?.copyWith(
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

      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 30, bottom: 50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Curated',
                      style: context.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 48,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Essentials',
                      style: context.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        color: context.colorScheme.primary,
                        fontSize: 48,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'A definitive selection of high-performance objects designed for the modern domestic space.',
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                BlocBuilder<SearchCubit, String>(
                  builder: (context, state) {
                    return SearchBar(
                      textInputAction: TextInputAction.search,
                      elevation: const WidgetStatePropertyAll(3.0),
                      hintText: "Search the atelier...",
                      hintStyle: WidgetStatePropertyAll(
                        context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                      leading: Icon(
                        Icons.search,
                        color: context.colorScheme.outline,
                      ),
                      onChanged: (val) {
                        context.read<SearchCubit>().search(val);
                      },
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Categories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      BlocBuilder<CategoryCubit, String>(
                        builder: (context, selected) {
                          return _buildCategoryChip(
                            'All Objects',
                            selected == 'All Objects',
                            context.colorScheme,
                            context.textTheme,
                            () => context.read<CategoryCubit>().selectCategory('All Objects'),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      BlocBuilder<CategoryCubit, String>(
                        builder: (context, selected) {
                          return _buildCategoryChip(
                            'Apparel',
                            selected == 'Apparel',
                            context.colorScheme,
                            context.textTheme,
                            () => context.read<CategoryCubit>().selectCategory('Apparel'),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      BlocBuilder<CategoryCubit, String>(
                        builder: (context, selected) {
                          return _buildCategoryChip(
                            'Accessories',
                            selected == 'Accessories',
                            context.colorScheme,
                            context.textTheme,
                            () => context.read<CategoryCubit>().selectCategory('Accessories'),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      BlocBuilder<CategoryCubit, String>(
                        builder: (context, selected) {
                          return _buildCategoryChip(
                            'Home Decor',
                            selected == 'Home Decor',
                            context.colorScheme,
                            context.textTheme,
                            () => context.read<CategoryCubit>().selectCategory('Home Decor'),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      BlocBuilder<CategoryCubit, String>(
                        builder: (context, selected) {
                          return _buildCategoryChip(
                            'Wellness',
                            selected == 'Wellness',
                            context.colorScheme,
                            context.textTheme,
                            () => context.read<CategoryCubit>().selectCategory('Wellness'),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      BlocBuilder<CategoryCubit, String>(
                        builder: (context, selected) {
                          return _buildCategoryChip(
                            'Limited Edition',
                            selected == 'Limited Edition',
                            context.colorScheme,
                            context.textTheme,
                            () => context.read<CategoryCubit>().selectCategory('Limited Edition'),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Filter & Grid Controls
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '248 ITEMS',
                          style: context.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.tune,
                                  size: 16,
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'FILTER',
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: context
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Row(
                              children: [
                                Text(
                                  'SORT BY',
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: context
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.expand_more,
                                  size: 16,
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      color: context.colorScheme.outlineVariant.withValues(
                        alpha: 0.2,
                      ),
                    ),
                  ],
                ),

                // Product Grid
                BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Loader();
                    } else if (state is ProductLoaded) {
                      return BlocBuilder<SearchCubit, String>(
                        builder: (context, searchQuery) {
                          final filteredProducts = state.products
                              .where(
                                (product) => product.name
                                    .toUpperCase()
                                    .startsWith(searchQuery.toUpperCase()),
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

                          return ProductGrid(
                            filteredProducts: filteredProducts,
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

                const SizedBox(height: 48),

                // Explore More
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          context.colorScheme.surfaceContainerHighest,
                      foregroundColor: context.colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'EXPLORE MORE',
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // body: Column(
      //   children: [
      //     Row(
      //       children: [
      //         Expanded(
      //           child: Padding(
      //             padding: const EdgeInsets.only(
      //               left: 15,
      //               right: 15,
      //               bottom: 10,
      //             ),
      // child: BlocBuilder<SearchCubit, String>(
      //   builder: (context, state) {
      //     return SearchBar(
      //       textStyle: WidgetStatePropertyAll(
      //         Theme.of(
      //           context,
      //         ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
      //       ),
      //       textInputAction: TextInputAction.search,
      //       elevation: const WidgetStatePropertyAll(3.0),
      //       hintText: "Search",
      //       hintStyle: WidgetStatePropertyAll(
      //         Theme.of(context).textTheme.titleMedium?.copyWith(
      //           color: AppColor.primary,
      //           fontWeight: FontWeight.normal,
      //         ),
      //       ),
      //       leading: const Icon(Icons.search, color: AppColor.secondary),
      //       onChanged: (val) {
      //         context.read<SearchCubit>().search(val);
      //       },
      //       onTapOutside: (event) => FocusScope.of(context).unfocus(),
      //     );
      //   },
      // ),
      //           ),
      //         ),
      //       ],
      //     ),
      //     SingleChildScrollView(
      //       scrollDirection: Axis.horizontal,
      //       clipBehavior: Clip.none,
      //       child: Row(
      //         children: [
      //           _buildCategoryChip('All Objects', true, colorScheme, textTheme),
      //           const SizedBox(width: 12),
      //           _buildCategoryChip('Apparel', false, colorScheme, textTheme),
      //           const SizedBox(width: 12),
      //           _buildCategoryChip(
      //             'Accessories',
      //             false,
      //             colorScheme,
      //             textTheme,
      //           ),
      //           const SizedBox(width: 12),
      //           _buildCategoryChip('Home Decor', false, colorScheme, textTheme),
      //           const SizedBox(width: 12),
      //           _buildCategoryChip('Wellness', false, colorScheme, textTheme),
      //           const SizedBox(width: 12),
      //           _buildCategoryChip(
      //             'Limited Edition',
      //             false,
      //             colorScheme,
      //             textTheme,
      //           ),
      //         ],
      //       ),
      //     ),

      //     Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(
      //               '248 ITEMS',
      //               style: textTheme.labelSmall?.copyWith(
      //                 fontWeight: FontWeight.bold,
      //                 letterSpacing: 1.5,
      //                 fontSize: 10,
      //               ),
      //             ),
      //             Row(
      //               children: [
      //                 Row(
      //                   children: [
      //                     Icon(
      //                       Icons.tune,
      //                       size: 16,
      //                       color: colorScheme.onSurfaceVariant,
      //                     ),
      //                     const SizedBox(width: 8),
      //                     Text(
      //                       'FILTER',
      //                       style: textTheme.labelSmall?.copyWith(
      //                         fontWeight: FontWeight.bold,
      //                         color: colorScheme.onSurfaceVariant,
      //                         fontSize: 10,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 const SizedBox(width: 24),
      //                 Row(
      //                   children: [
      //                     Text(
      //                       'SORT BY',
      //                       style: textTheme.labelSmall?.copyWith(
      //                         fontWeight: FontWeight.bold,
      //                         color: colorScheme.onSurfaceVariant,
      //                         fontSize: 10,
      //                       ),
      //                     ),
      //                     const SizedBox(width: 4),
      //                     Icon(
      //                       Icons.expand_more,
      //                       size: 16,
      //                       color: colorScheme.onSurfaceVariant,
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //         const SizedBox(height: 16),
      //         Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
      //       ],
      //     ),

      //     BlocBuilder<ProductCubit, ProductState>(
      //       builder: (context, state) {
      //         if (state is ProductLoading) {
      //           return const Loader();
      //         } else if (state is ProductLoaded) {
      //           return BlocBuilder<SearchCubit, String>(
      //             builder: (context, searchQuery) {
      //               final filteredProducts = state.products
      //                   .where(
      //                     (product) => product.name.toUpperCase().startsWith(
      //                       searchQuery.toUpperCase(),
      //                     ),
      //                   )
      //                   .toList();
      //               if (filteredProducts.isEmpty) {
      //                 return const Center(
      //                   child: Text(
      //                     'No products found',
      //                     style: TextStyle(fontSize: 15),
      //                   ),
      //                 );
      //               }
      //               return Expanded(
      //                 child: ProductGrid(filteredProducts: filteredProducts),
      //               );
      //             },
      //           );
      //         } else if (state is ProductFailure) {
      //           return Center(child: Text(state.message));
      //         } else {
      //           return const SizedBox();
      //         }
      //       },
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildCategoryChip(
    String text,
    bool isSelected,
    ColorScheme colorScheme,
    TextTheme textTheme,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: textTheme.labelLarge?.copyWith(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
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
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
    );
  }
}
