import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_commerce_client/presentation/blocs/checkout/checkout_bloc.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/entity/address/address_entity.dart';
import '../../models/checkout_data.dart';

class CheckoutScreen extends StatefulWidget {
  final CheckoutData? checkoutData;
  const CheckoutScreen({super.key, this.checkoutData});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _deliveryMethod = 0; // 0 for Standard, 1 for Express

  @override
  Widget build(BuildContext context) {
    double subtotal = widget.checkoutData?.subtotal ?? 0.0;
    double shipping = widget.checkoutData?.shipping ?? 0.0;
    double total = widget.checkoutData?.total ?? subtotal + shipping;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.theme.colorScheme.surfaceContainerLow,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: context.theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Shipping Address
            _buildSectionHeader('Shipping'),
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return _buildAddressCard(
                  address: state.selectedAddress,
                  onSelectMap: () =>
                      _onSelectAddressOnMap(state.selectedAddress),
                );
              },
            ),
            const SizedBox(height: 32),

            // Section 2: Delivery Method
            _buildSectionHeader('Delivery Method'),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDeliveryOption(
                    value: 0,
                    title: 'Standard Curation',
                    subtitle: 'Delivered in 3-5 business days',
                    price: 'Free',
                  ),
                  Container(
                    height: 1,
                    color: context.theme.colorScheme.surface,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  _buildDeliveryOption(
                    value: 1,
                    title: 'Express Courier',
                    subtitle: 'Delivered in 1-2 business days',
                    price: '\$15.00',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Section 3: Payment
            _buildSectionHeader(
              'Payment',
              actionText: 'Change',
              onActionTap: () {},
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'VISA',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w800,
                        color: context.theme.colorScheme.primary,
                        fontSize: 12,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visa ending in 4242',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Expires 12/27',
                          style: GoogleFonts.plusJakartaSans(
                            color: context.theme.colorScheme.secondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Section 4: Order Summary
            _buildSectionHeader('Order Summary'),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    'Subtotal',
                    '\$${subtotal.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    'Curated Shipping',
                    shipping == 0.0
                        ? 'Free'
                        : '\$${shipping.toStringAsFixed(2)}',
                  ),
                  // const SizedBox(height: 12),
                  // _buildSummaryRow(
                  //   'Estimated Tax',
                  //   '\$${tax.toStringAsFixed(2)}',
                  // ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: context.theme.colorScheme.surfaceContainerLow,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: GoogleFonts.manrope(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Action Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    context.theme.colorScheme.primary,
                    context.theme.colorScheme.primaryContainer,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.theme.colorScheme.primary.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Complete Order',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    String? actionText,
    VoidCallback? onActionTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: context.theme.colorScheme.onSurface,
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: context.theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeliveryOption({
    required int value,
    required String title,
    required String subtitle,
    required String price,
  }) {
    final isSelected = _deliveryMethod == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _deliveryMethod = value;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? context.theme.colorScheme.primary
                      : context.theme.colorScheme.outline.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: context.theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: context.theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected
                    ? context.theme.colorScheme.primary
                    : context.theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: context.theme.colorScheme.secondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Future<void> _onSelectAddressOnMap(AddressEntity? currentAddress) async {
    final result = await context.pushNamed(
      AppRouter.pickAddressName,
      extra: currentAddress,
    );

    if (!mounted) {
      return;
    }

    if (result is AddressEntity) {
      context.read<CheckoutBloc>().add(UpdateCheckoutAddressEvent(result));
    }
  }

  Widget _buildAddressCard({
    required AddressEntity? address,
    required VoidCallback onSelectMap,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surfaceContainerLow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  color: context.theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.onSurface,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address?.formattedAddress ??
                          'No address selected yet. Tap below to select on map.',
                      style: GoogleFonts.plusJakartaSans(
                        color: context.theme.colorScheme.secondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onSelectMap,
              icon: const Icon(Icons.map_outlined),
              label: Text(address == null ? 'Select on Map' : 'Edit on Map'),
            ),
          ),
        ],
      ),
    );
  }
}
