import 'dart:math' show min;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/common/widgets/loader.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../core/routes/app_router.dart';
import '../blocs/product/product_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().loadProducts();
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
                onPressed: () {
                  context.goNamed(AppRouter.cartName);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 150, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 4 / 5,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCmj49mhgcYWlriJDCZI8cuehYQaEsoD0F3SXtTupaYE4mlZzssOoaw4Ja1605Grv1E-1jM2ApAuMi4PPmmaGvjVDEaif4mLxwE-nZ1am4HPayjtxCZaUTa-671IuDW3aNmeSLlo_hVKXYuDUl_undr6AsZsT8GiBKaywBgkFXyj2FeyxPnUMJ1gRl4B5Dm2_s-Z2kNMFqlJGwj8VppiAq5FttV18vrkhp4VKDfIv3Epy3rwI7UdWdMEP3yLI9J4oGRuK4h7dPfZB0X',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 24,
                          bottom: 32,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'SS/24 COLLECTION',
                                  style: context.textTheme.labelSmall?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    letterSpacing: 2,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'The Modern \nMinimalist',
                                style: context.textTheme.headlineLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 40,
                                      height: 1.1,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '01',
                          style: context.textTheme.headlineSmall?.copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Curated Essentials',
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'A selection of pieces designed to transcend seasons and trends. Quality over quantity, always.',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.secondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            context.goNamed(AppRouter.productSearchName);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Explore Now',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // New Arrivals
            Container(
              color: context.colorScheme.surfaceContainerLow,
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'JUST IN',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'New Arrivals',
                              style: context.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Text(
                                'View All',
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: context.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Loader();
                      } else if (state is ProductLoaded) {
                        return SizedBox(
                          height: 380,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            scrollDirection: Axis.horizontal,
                            // Prevent RangeError by capping the itemCount to available products
                            itemCount: min(state.products.length, 10),
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final item = state.products[index];
                              return GestureDetector(
                                onTap: () {
                                  context.pushNamed(
                                    AppRouter.productDetailsName,
                                    pathParameters: {'id': item.id},
                                  );
                                },
                                child: SizedBox(
                                  width: 220,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: item.imageUrl,
                                                fit: BoxFit.fill,
                                                width: double.infinity,
                                                placeholder: (context, url) =>
                                                    Container(
                                                      width: double.infinity,
                                                      color: Colors.grey[200],
                                                      child: const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      ),
                                                    ),
                                                errorWidget: (context, url, error) {
                                                  return Container(
                                                    width: double.infinity,
                                                    color: Colors.grey[300],
                                                    child: SizedBox.expand(
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Positioned(
                                                top: 12,
                                                right: 12,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white
                                                      .withOpacity(0.8),
                                                  radius: 18,
                                                  child: const Icon(
                                                    Icons.favorite_border,
                                                    size: 18,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        item.name,
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "\$${item.finalPrice.toStringAsFixed(2)}",
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                              color:
                                                  context.colorScheme.secondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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
            ),

            const SizedBox(height: 48),

            // Selected For You
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    'Selected For You',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Bento Grid
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductDetailsScreen()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCuwulb1RjHeZxO5wpAzhvs4hLOABTBqDsfeAY0uNrE1yTsp582X5-KKI_R4tdPfbuME48hz-MNHQBZE8LvhmgRtHGLX3mzimJx9bEW4hQfKcKv3y4RBFQSGzeT8n3q7Jb8SEKFz-U0hXiZl1tsGNt4Bujjqj03Ft-2hE2UoaXrVJNvhWPm_bRt9KChrCLFIjwTNKrf9gZq_dFx3USFNC9h8vd0K37odJrRT82QCEpwRpcn-wvomBJqS4nO4nkxFKAlEFWj3VSpOZ0o',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            bottom: 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primary,
                                  ),
                                  child: Text(
                                    'TRENDING NOW',
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 10,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'The Linen Edit',
                                  style: context.textTheme.headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Shop Collection',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductDetailsScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: context.colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuD_kUq9xQM5I_n7C8IrSORhr6FW1MQ264w4M897b3vhmV-r4kV4qMGctfdaql1REd3tOESo-QY9r-JODT8XQIZPlffXGSBH1nUKhl4bYq-UPjecLIoyK23ses1yuaxxJe5o7tnMhJtCYT8WZWreFpTP0PsC-BpewO3crisUA9qQ-fRmYANJgq8GZk8ComGH_F5OM3DAoqzdkMb1j-j_oiezzUZd7C5Cr5DZOuJFcm5swbM1e0ejMhUZZDdccH7YvDV0R-PSm_kzT9fP',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Legacy Watch',
                                  style: context.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$890',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: context.colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAUwtYRM7hM0Zf96eQMISnXCMPo6LdBO2JI1PcOrv7B3YvhehJR_KKrU1R1AL-KE4Hj15nD96AnkqWwyrSDpufgL_HkuErOOomCJUsHNKUZsRQmk3pjkd7ZesGztpbeRpx74QnKzR3oO34Esil03QpACZTV77AVDh-egnHIb8xoPWJlV883nZXuB9btcKCxnykzUlhsJQcQsz6dvKuP3lZF-h7XBOcs9rtAYj3dqpEohw19DKFYhcNUJ4mnIEyc7-ZqXZSAesMPEP08',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Nova Smart',
                                style: context.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$350',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
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
}
