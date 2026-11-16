import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/common/widgets/loader.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../core/routes/app_router.dart';
import '../../cubits/wishlist/wishlist_cubit.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        if (state is WishlistLoading) {
          return const Scaffold(body: Loader());
        }

        if (state is WishlistFailure) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                style: GoogleFonts.plusJakartaSans(
                  color: context.colorScheme.error,
                ),
              ),
            ),
          );
        }

        if (state is! WishlistLoaded) {
          return const Scaffold(body: Loader());
        }

        return Scaffold(
          appBar: _buildAppBar(context, state.wishlist.isNotEmpty),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FAVORITES',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: context.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Wishlist',
                    style: GoogleFonts.manrope(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (state.wishlist.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Text(
                          'Your wishlist is empty.',
                          style: GoogleFonts.plusJakartaSans(
                            color: context.colorScheme.outline,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.wishlist.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = state.wishlist[index];
                        return _WishlistItem(
                          imageUrl: item.imageUrl,
                          name: item.name,
                          price: item.finalPrice,
                          onTap: () => context.pushNamed(
                            AppRouter.productDetailsName,
                            pathParameters: {'id': item.productId},
                          ),
                          onRemove: () => context
                              .read<WishlistCubit>()
                              .removeWishlist(item.productId),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool hasItems) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'ATELIER',
        style: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
        ),
      ),
      actions: [
        if (hasItems)
          IconButton(
            tooltip: 'Clear wishlist',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => context.read<WishlistCubit>().clearWishlist(),
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _WishlistItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _WishlistItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    width: 80,
                    height: 80,
                    color: context.colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (_, _, _) => Container(
                    width: 80,
                    height: 80,
                    color: context.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: context.colorScheme.outline,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: GoogleFonts.plusJakartaSans(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remove from wishlist',
                icon: Icon(
                  Icons.delete_outline,
                  color: context.colorScheme.tertiary,
                ),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
