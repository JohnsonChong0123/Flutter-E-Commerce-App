import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../core/routes/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                onPressed: () {},
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
                          child: Image.network(
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
                                style: context.textTheme.headlineLarge?.copyWith(
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
                  SizedBox(
                    height: 380,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: _newArrivals.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final item = _newArrivals[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductDetailsScreen()));
                          },
                          child: SizedBox(
                            width: 220,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          item['image']!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
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
                                  item['title']!,
                                  style: context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['price']!,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.secondary,
                                  ),
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
                            child: Image.network(
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
                                    style: context.textTheme.labelSmall?.copyWith(
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
                                  style: context.textTheme.headlineSmall?.copyWith(
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
                                    child: Image.network(
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
                                  child: Image.network(
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

  static const List<Map<String, String>> _newArrivals = [
    {
      'title': 'Wool Car Coat',
      'price': '\$450.00',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBXEYbd3f48xDiH6iOoJ_tcTSTaLYwBPHcMKBgshZFMG9SoXHZfuhwSWlecPXiDM8ccn_PcAP7dmiip4Yk19A91jmaSOwSe53qWvxs2uOIUITld76xdjGDR-nnduoYUrb3IfUZEM6EvxluCkyFZZzdgRKlQaDDMPWDm2gcxQ5yhT_FiS7R9IAScGh4EdwuIBuV8FoKPiRPLRasTEMf5vRPYmbJSjOOmc2U7bl0R8E5AH4YlXrTwfmBj0Dht-8qdnyJmqUgExAinwLil',
    },
    {
      'title': 'Velocity Runner',
      'price': '\$180.00',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBK35cR4fcT9uT4jbC5GNv2OaJm90ecJi2RdWZOJS9yGTnEkvGVkwki7ydDIqyofjqmDgGtQv7rgfQntGBTQCw0DF3u-eKq2Q8g_YyU6qnFuyKPMNtc1s2_j9P1ZYxVH8a1slhx2XoiL0ei7GMCjXPq5hLDRkZNV4Efb_0Ytw_wa5DrK0B46NQIjDvOhqO28FcUQAD-815btx7ye_k1GeM3B-k4n8aJKPc-dZFVMjX1sGMg9TvABwHZvHvmf2J699lUfiPousxFzS9R',
    },
    {
      'title': 'Chelsea Archive',
      'price': '\$320.00',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBdL7n0tGcwxKle6VNiuREi2cMwwuhTUm9393J9Mxqg1o-Ezw9VXrcu1F3Qbx92Otjpzo2_el0-R4yD5dZm9xTGwHpR_G6MRziOkKtsSKRvw1br85FgJLPZDWJ4JBoB6m0y6hAInpQVHA4H5csqUZc652QvM_2jNWoVNaOCwb-A4zt09CsI29kELKze9rZUIA5fnCIySOl9aIJDz7aixoVpD6abuqgUtMcN4_sZd5dEiYat-SN3cOEv3rVIrDhHSQndLMo0GEGPknJz',
    },
    {
      'title': 'Structure Tote',
      'price': '\$295.00',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAO_u1wZ5lU8socBwnvFjHVX_MY2bhZlv5HhFEyIc9cDRGMbcUZ7YxNS--yPKWAxvtanZaa6T6rUDmeyiX_CevxhLru4HI5hRh-z_2KuUWgrd9Xht2h0V4zY0V3aROKcvHoz7xSCLYPcxndan2OC00S9gRUJdcno7T6xS1BpU4A4MNSzFcSwytGehCy3iwy6xfqW87_03XjTxjyPhpfBn1Oi5zFmNnfezpwafwjq6EsH9ZDzTKPfvhhMdsxx4TSmtRSNbQhZhz-nzWf',
    },
  ];
}
