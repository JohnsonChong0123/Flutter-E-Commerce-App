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
import '../../models/product_display_aspect.dart';
import '../../notifiers/product_details_notifier.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: BlocBuilder<ProductBloc, ProductState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: Loader());
          }

          if (state is ProductDetailsLoaded) {
            return ProductDetailContent(
              product: state.product,
              aspects: state.aspect,
              shippingAspects: state.shippingAspects,
            );
          }

          if (state is ProductFailure) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Loader());
        },
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
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
    );
  }
}

class ProductDetailContent extends StatelessWidget {
  final ProductDetailsEntity product;
  final List<ProductDisplayAspect> aspects;
  final Map<String, List<ProductDisplayAspect>> shippingAspects;

  const ProductDetailContent({
    super.key,
    required this.product,
    required this.aspects,
    required this.shippingAspects,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top,
        bottom: 64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Gallery
          _ProductImageGallery(product: product),

          const SizedBox(height: 32),

          // Product Info
          _ProductHeader(product: product),

          const SizedBox(height: 32),

          // Details Expansion Panels
          _ProductExpansionPanels(
            product: product,
            aspects: aspects,
            shippingAspects: shippingAspects,
          ),
        ],
      ),
    );
  }
}

class _ProductImageGallery extends StatelessWidget {
  final ProductDetailsEntity product;

  const _ProductImageGallery({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Main Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),
          // Additional Images
          Column(
            children: [
              if (product.additionalImages.isNotEmpty)
                SizedBox(
                  height: 180,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: product.additionalImages.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: Image.network(
                            product.additionalImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductHeader extends StatelessWidget {
  final ProductDetailsEntity product;

  const _ProductHeader({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: context.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _FavoriteButton(),
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
            onPressed: () => _showCartDialog(context, product),
            title: 'Add To Cart',
          ),
        ],
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

class _ProductExpansionPanels extends StatelessWidget {
  final ProductDetailsEntity product;
  final List<ProductDisplayAspect> aspects;
  final Map<String, List<ProductDisplayAspect>> shippingAspects;

  const _ProductExpansionPanels({
    required this.product,
    required this.aspects,
    required this.shippingAspects,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Product Description
            Theme(
              data: context.theme.copyWith(dividerColor: Colors.transparent),
              child: _AdaptiveExpansionTile(
                title: 'NARRATIVE & COMPOSITION',
                initiallyExpanded: true,
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Text(
                    product.description,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Product Details
            Theme(
              data: context.theme.copyWith(dividerColor: Colors.transparent),
              child: _AdaptiveExpansionTile(
                title: 'PRODUCT DETAILS',
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: aspects.isEmpty
                    ? [const Text('No product details available.')]
                    : aspects
                          .map(
                            (a) => _KeyValueRow(label: a.name, value: a.value),
                          )
                          .toList(),
              ),
            ),
            const Divider(height: 1),
            // 3. Shipping
            Theme(
              data: context.theme.copyWith(dividerColor: Colors.transparent),
              child: _AdaptiveExpansionTile(
                title: 'SHIPPING',
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [_buildShippingContent(context)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingContent(BuildContext context) {
    if (shippingAspects.isEmpty) {
      return const Text('No shipping details available.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: shippingAspects.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.key.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ...entry.value.map(
              (item) =>
                  _KeyValueRow(label: '• ${item.name}', value: item.value),
            ),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }
}

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
  late final ExpansibleController _controller;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _controller = ExpansibleController();
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

    return Theme(
      data: context.theme.copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        controller: _controller,
        title: Text(
          widget.title,
          style: _isExpanded ? expandedStyle : collapsedStyle,
        ),
        initiallyExpanded: widget.initiallyExpanded,
        childrenPadding: widget.childrenPadding,
        onExpansionChanged: (val) => setState(() => _isExpanded = val),
        children: widget.children,
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  const _KeyValueRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.textTheme.bodySmall,
            ),
          ),
        ],
      ),
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

class _FavoriteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.favorite_border,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
