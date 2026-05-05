import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/common/utils/show_snackbar.dart';
import '../../../core/common/widgets/app_button.dart';
import '../../../core/common/widgets/loader.dart';
import '../../../core/extensions/currency_extension.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../domain/entity/product/product_details_entity.dart';
import '../../blocs/product/product_bloc.dart';
import '../../cubits/cart/cart_cubit.dart';
import '../../notifiers/product_details_notifier.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: ClipRect(
          child: AppBar(
            backgroundColor: Colors.white.withValues(alpha: 0.7),
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.grey.shade600,
              onPressed: () => Navigator.pop(context),
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
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Loader();
          }

          if (state is ProductDetailsLoaded) {
            final product = state.product;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  // Image Gallery
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 4 / 5,
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 180,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(2, (index) {
                              final hasImage =
                                  product.additionalImages.length > index &&
                                  product.additionalImages[index].isNotEmpty;

                              final imageWidget = ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: hasImage
                                      ? Image.network(
                                          product.additionalImages[index],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                          ),
                                        ),
                                ),
                              );

                              // Return an Expanded directly to be a direct child of Row.
                              // For the second thumbnail, put padding inside the Expanded.
                              if (index == 0) {
                                return Expanded(child: imageWidget);
                              }

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: imageWidget,
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Product Info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    product.name,
                                    style: context.textTheme.headlineLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 32,
                                          height: 1.1,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: context.colorScheme.surfaceContainerLow,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product.finalPrice.formatCurrency(product.currency),
                          style: context.textTheme.headlineMedium?.copyWith(
                            color: context.colorScheme.secondary,
                          ),
                        ),

                        const SizedBox(height: 32),

                        AppButton(
                          onPressed: () {
                            _showCartDialog(context, product);
                          },
                          title: 'Add To Cart',
                        ),

                        const SizedBox(height: 32),

                        // Details
                        Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Theme(
                                data: context.theme.copyWith(
                                  dividerColor: Colors.transparent,
                                ),
                                child: _AdaptiveExpansionTile(
                                  title: 'NARRATIVE & COMPOSITION',
                                  initiallyExpanded: true,
                                  childrenPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  children: [
                                    Text(
                                      product.description,
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: context
                                                .colorScheme
                                                .onSurfaceVariant,
                                            height: 1.5,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              // PRODUCT DETAILS / Localized Aspects
                              Theme(
                                data: context.theme.copyWith(
                                  dividerColor: Colors.transparent,
                                ),
                                child: _AdaptiveExpansionTile(
                                  title: 'PRODUCT DETAILS',
                                  initiallyExpanded: false,
                                  childrenPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  children: [
                                    if (state.aspect.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Text(
                                          'No product details available.',
                                          style: context.textTheme.bodySmall
                                              ?.copyWith(
                                                color: context
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      )
                                    else
                                      Column(
                                        children: state.aspect
                                            .map(
                                              (aspect) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        aspect.name,
                                                        style: context
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Flexible(
                                                      child: Text(
                                                        aspect.value,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: context
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              color: context
                                                                  .colorScheme
                                                                  .onSurfaceVariant,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              Theme(
                                data: context.theme.copyWith(
                                  dividerColor: Colors.transparent,
                                ),
                                child: _AdaptiveExpansionTile(
                                  title: 'SHIPPING',
                                  initiallyExpanded: false,
                                  childrenPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  children: [
                                    if (state.shippingAspects.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Text(
                                          'No shipping details available.',
                                          style: context.textTheme.bodySmall
                                              ?.copyWith(
                                                color: context
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      )
                                    else
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: () {
                                          final widgets = <Widget>[];
                                          state.shippingAspects.forEach((prefix, items) {
                                            if (prefix.isNotEmpty) {
                                              widgets.add(Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Text(
                                                  prefix,
                                                  style: context.textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ));
                                            }

                                            for (final item in items) {
                                              widgets.add(Padding(
                                                padding: const EdgeInsets.only(bottom: 8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '• ${item.name}',
                                                        style: context.textTheme.bodyMedium?.copyWith(
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Flexible(
                                                      child: Text(
                                                        item.value,
                                                        textAlign: TextAlign.end,
                                                        style: context.textTheme.bodySmall?.copyWith(
                                                          color: context.colorScheme.onSurfaceVariant,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                            }

                                            widgets.add(const SizedBox(height: 6));
                                          });

                                          return widgets;
                                        }(),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 64),
                ],
              ),
            );
          }

          if (state is ProductFailure) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showCartDialog(BuildContext context, ProductDetailsEntity product) {
    final cartCubit = context.read<CartCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => BlocProvider.value(
        value: cartCubit,
        child: ChangeNotifierProvider(
          create: (_) => ProductDetailsNotifier(price: product.finalPrice),
          child: CartDialog(product: product),
        ),
      ),
    );
  }
}

// New adaptive ExpansionTile that changes its title style when expanded vs collapsed.
class _AdaptiveExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final EdgeInsetsGeometry? childrenPadding;

  const _AdaptiveExpansionTile({
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
    this.childrenPadding,
  });

  @override
  State<_AdaptiveExpansionTile> createState() => _AdaptiveExpansionTileState();
}

class _AdaptiveExpansionTileState extends State<_AdaptiveExpansionTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final collapsedStyle = context.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: 1.5,
      fontSize: 12,
      color: context.colorScheme.onSurface.withValues(alpha: 0.5),
    );

    final expandedStyle = context.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: 1.5,
      fontSize: 12,
    );

    return ExpansionTile(
      title: Text(
        widget.title,
        style: _isExpanded ? expandedStyle : collapsedStyle,
      ),
      initiallyExpanded: widget.initiallyExpanded,
      childrenPadding: widget.childrenPadding,
      onExpansionChanged: (val) => setState(() => _isExpanded = val),
      children: widget.children,
    );
  }
}

class CartDialog extends StatelessWidget {
  final ProductDetailsEntity product;

  const CartDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartSuccess) {
          Navigator.of(context).pop();
          showSnackBar(context, "Added to cart");
        } else if (state is CartFailure) {
          Navigator.of(context).pop();
          showSnackBar(context, "Failed to add: ${state.message}");
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(product.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Consumer<ProductDetailsNotifier>(
              builder: (context, notifier, _) {
                return Text(
                  "\$${notifier.price.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity',
                  style: TextStyle(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 15,
                  ),
                ),
                Consumer<ProductDetailsNotifier>(
                  builder: (context, notifier, _) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            notifier.minusQuantity();
                          },
                          icon: Icon(
                            Icons.remove,
                            color: context.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${notifier.quantity}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () {
                            notifier.addQuantity();
                          },
                          icon: Icon(
                            Icons.add,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppButton(
              onPressed: () {
                final notifier = context.read<ProductDetailsNotifier>();
                context.read<CartCubit>().addToCart(
                  productId: product.id,
                  quantity: notifier.quantity,
                );
              },
              title: 'Add to cart',
            ),
          ],
        ),
      ),
    );
  }
}
