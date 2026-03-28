import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/common/utils/show_snackbar.dart';
import '../../../core/common/widgets/app_button.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/themes/app_colors.dart';
import '../../../domain/entity/product/product_details_entity.dart';
import '../../cubits/cart/cart_cubit.dart';
import '../../cubits/product/product_cubit.dart';
import '../../cubits/wishlist/wishlist_cubit.dart';
import '../../notifiers/product_details_notifier.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back, color: AppColor.primary),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                context.goNamed(AppRouter.cartName);
              },
              icon: const Icon(Icons.shopping_cart, color: AppColor.primary),
            ),
          ],
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductDetailsLoaded) {
              final product = state.product;

              return _buildContent(context, product);
            }

            if (state is ProductFailure) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
        bottomNavigationBar: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: () {
            final state = context.read<ProductCubit>().state;

            if (state is ProductDetailsLoaded) {
              _showCartDialog(context, state.product);
            }
          },
          child: const Text(
            'Add to cart',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProductDetailsEntity product) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 100,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ),
                      WishlistButton(product.id),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "\$${product.finalPrice.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColor.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'DESCRIPTION',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text(
                          "View Review >>>",
                          style: TextStyle(color: AppColor.green),
                        ),
                        onPressed: () {
                          // TODO: Navigate to review screen
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  color: AppColor.placeholder,
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
                    color: AppColor.green,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quantity',
                  style: TextStyle(color: AppColor.primary, fontSize: 15),
                ),
                Consumer<ProductDetailsNotifier>(
                  builder: (context, notifier, _) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            notifier.minusQuantity();
                          },
                          icon: const Icon(Icons.remove, color: Colors.green),
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
                          icon: const Icon(Icons.add, color: Colors.green),
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

class WishlistButton extends StatelessWidget {
  final String productId;
  const WishlistButton(this.productId, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        final isFavorite =
            state is WishlistLoaded && state.favoriteIds.contains(productId);
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            if (isFavorite) {
              context.read<WishlistCubit>().removeWishlist(productId);
              showSnackBar(context, "Removed from wishlist");
            } else {
              context.read<WishlistCubit>().addWishlist(productId);
              showSnackBar(context, "Added to wishlist");
            }
          },
        );
      },
    );
  }
}
