import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/currency_extension.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../blocs/cart/cart_bloc.dart'; // contains CartBloc and events now

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // switch from calling cubit method to adding GetCartEvent to the bloc
    context.read<CartBloc>().add(const GetCartEvent());
  }

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
              icon: const Icon(Icons.menu),
              color: Colors.grey.shade600,
              onPressed: () {},
            ),
            title: Text(
              'ATELIER',
              style: context.theme.textTheme.titleMedium?.copyWith(
                letterSpacing: 4.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_bag,
                  color: Colors.blue,
                ), // Highlighted in design
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 150, bottom: 50),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Editorial Header
              Text(
                'YOUR BAG',
                style: context.theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A curated selection of your future essentials.',
                style: context.theme.textTheme.bodyLarge?.copyWith(
                  color: context.theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 32),

              // Cart-specific content
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CartFailure) {
                    return Center(child: Text(state.message));
                  } else if (state is CartLoaded) {
                    final cartItems = state.carts.items;
                    final cartTotal = state.carts.cartTotal;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (cartItems.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 60.0),
                              child: Text("Your bag is empty"),
                            ),
                          )
                        else
                          ...cartItems.asMap().entries.map((entry) {
                            final item = entry.value;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: _buildCartItem(
                                context.theme.colorScheme,
                                context.theme.textTheme,
                                item.name,
                                'Quantity: ${item.quantity}',
                                item.price.formatCurrency('USD'),
                                item.imageUrl,
                                item.productId, // new: pass productId
                                item.quantity,
                                null,
                              ),
                            );
                          }),

                        const SizedBox(height: 48),

                        // Order Summary
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color:
                                context.theme.colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SUMMARY',
                                style: context.theme.textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                              ),
                              const SizedBox(height: 24),
                              // Use subtotal from CartNotifiers (sum of all registered notifiers)
                              _buildSummaryRow(
                                context.theme.textTheme,
                                context.theme.colorScheme,
                                'Subtotal',
                                '\$${cartTotal.toStringAsFixed(2)}',
                              ),

                              const SizedBox(height: 16),
                              _buildSummaryRow(
                                context.theme.textTheme,
                                context.theme.colorScheme,
                                'Shipping',
                                '\$45.00',
                              ),
                              const SizedBox(height: 16),
                              _buildSummaryRow(
                                context.theme.textTheme,
                                context.theme.colorScheme,
                                'Estimated Tax',
                                '\$168.00',
                              ),

                              const SizedBox(height: 24),
                              const Divider(),
                              const SizedBox(height: 16),

                              Text(
                                'PROMO CODE',
                                style: context.theme.textTheme.labelSmall
                                    ?.copyWith(
                                      color: context.theme.colorScheme.outline,
                                      letterSpacing: 1.5,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 48,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context
                                            .theme
                                            .colorScheme
                                            .surfaceContainerLowest,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'ENTER CODE',
                                          hintStyle: context
                                              .theme
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: context
                                                    .theme
                                                    .colorScheme
                                                    .outlineVariant,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          context.theme.colorScheme.onSurface,
                                      foregroundColor:
                                          context.theme.colorScheme.surface,
                                      minimumSize: const Size(80, 48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'APPLY',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'TOTAL',
                              style: context.theme.textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                            ),
                            Text(
                              '\$${cartTotal.toStringAsFixed(2)}',
                              style: context.theme.textTheme.headlineLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: context.theme.colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Proceed Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context
                                .theme
                                .colorScheme
                                .primary, // using solid primary instead of gradient for simplicity
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                            shadowColor: context.theme.colorScheme.primary
                                .withValues(alpha: 0.4),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'PROCEED TO CHECKOUT',
                                style: context.theme.textTheme.labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock,
                              size: 16,
                              color: context.theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'ENCRYPTED CHECKOUT',
                              style: context.theme.textTheme.labelSmall
                                  ?.copyWith(
                                    color: context.theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                    letterSpacing: 1.5,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCartItem(
    ColorScheme colorScheme,
    TextTheme textTheme,
    String title,
    String subtitle,
    String price,
    String imgUrl,
    String productId, // added productId
    int quantity,
    String? tag,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 100,
                  height: 120,
                  child: Image.network(imgUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.close,
                            color: colorScheme.outline,
                            size: 20,
                          ),
                          onPressed: () async {
                            // dispatch remove event
                            context.read<CartBloc>().add(RemoveCartItemEvent(productId));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (tag != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          tag.toUpperCase(),
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onTertiaryContainer,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // Quantity controls: call CartBloc by adding events on change
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.remove, size: 16),
                      onPressed: () async {
                        final bloc = context.read<CartBloc>();
                        if (quantity > 1) {
                          bloc.add(UpdateCartEvent(productId: productId, quantity: quantity - 1));
                        } else {
                          // if quantity would go to 0, remove the item
                          bloc.add(RemoveCartItemEvent(productId));
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Text(
                        quantity.toString(),
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.add, size: 16),
                      onPressed: () async {
                        context.read<CartBloc>().add(UpdateCartEvent(productId: productId, quantity: quantity + 1));
                      },
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
