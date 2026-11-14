import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/common/utils/show_snackbar.dart';
import '../../core/extensions/theme_extensions.dart';
import '../blocs/auth/auth_bloc.dart';
import 'wishlist/wishlist_screen.dart';

// // Import all sub-screens
// import 'personal_info_screen.dart';
// import 'addresses_screen.dart';
// import 'payments_screen.dart';
// import 'order_history_screen.dart';
// import 'wishlist_screen.dart';
// import 'notifications_screen.dart';
// import 'language_screen.dart';
// import 'security_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (_, state) => state is AuthFailure,
      listener: (context, state) {
        showSnackBar(context, (state as AuthFailure).message);
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile image with verified badge
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.theme.colorScheme.surfaceContainerHigh,
                        width: 4,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBSyItw-eBkI6SKFK2w2CeNFe10GjDkShuPejjvQ2Q3TJ85wJftLk8cAXuc4bchHsunMLxA1ZazC14eRNnWm0RIjETjRJEdRjwaET86ezS81dpoGLwtnn5PLCxiO34SQkZIZsFlYNo7WuwwuXlx08a1W_XyjGIOsNvukwlfMqiqXxzqcrC6Yy7X-M8R9ZmdGsVTsvrWTUqmonAHPY32eYZs3cMhPFRG4HpQWC0yJdBf7zS7otPXpf0SdW9MwRPufSARwVySPpNqp51c',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // User Name & Membership tag
            Text(
              'ALEXANDER LUMIÈRE',
              style: GoogleFonts.manrope(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ELITE MEMBER',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: context.theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Categories List
            _buildMenuSection(context, 'Account', [
              _MenuOption(
                Icons.person_outline,
                'Personal Info',
                const _ProfilePlaceholderScreen(title: 'Personal Info'),
              ),
              _MenuOption(
                Icons.location_on_outlined,
                'Addresses',
                const _ProfilePlaceholderScreen(title: 'Addresses'),
              ),
              _MenuOption(
                Icons.payments_outlined,
                'Payments',
                const _ProfilePlaceholderScreen(title: 'Payments'),
              ),
            ]),
            const SizedBox(height: 32),

            _buildMenuSection(context, 'Shopping', [
              _MenuOption(
                Icons.history,
                'Order History',
                const _ProfilePlaceholderScreen(title: 'Order History'),
              ),
              _MenuOption(
                Icons.favorite_border,
                'Wishlist',
                const WishlistScreen(),
              ),
            ]),
            const SizedBox(height: 32),

            _buildMenuSection(context, 'General', [
              _MenuOption(
                Icons.notifications_none,
                'Notifications',
                const _ProfilePlaceholderScreen(title: 'Notifications'),
              ),
              _MenuOption(
                Icons.language,
                'Language',
                const _ProfilePlaceholderScreen(title: 'Language'),
              ),
              _MenuOption(
                Icons.shield_outlined,
                'Security',
                const _ProfilePlaceholderScreen(title: 'Security'),
              ),
            ]),
            const SizedBox(height: 40),

            // Sign out button
            TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.logout,
                color: context.theme.colorScheme.tertiary,
                size: 16,
              ),
              label: Text(
                'SIGN OUT',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: context.theme.colorScheme.tertiary,
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<_MenuOption> options,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
              color: context.theme.colorScheme.secondary.withValues(alpha: 0.8),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: context.theme.colorScheme.onSurface.withValues(
                  alpha: 0.02,
                ),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isLast = index == options.length - 1;

              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => option.destination,
                        ),
                      );
                    },
                    leading: Icon(
                      option.icon,
                      color: context.theme.colorScheme.primary,
                      size: 22,
                    ),
                    title: Text(
                      option.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: context.theme.colorScheme.outline,
                      size: 18,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: context.theme.colorScheme.surfaceContainerLow,
                      indent: 20,
                      endIndent: 20,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuOption {
  final IconData icon;
  final String title;
  final Widget destination;

  _MenuOption(this.icon, this.title, this.destination);
}

class _ProfilePlaceholderScreen extends StatelessWidget {
  final String title;

  const _ProfilePlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title is not available yet.')),
    );
  }
}
