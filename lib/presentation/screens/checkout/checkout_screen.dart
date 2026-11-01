import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../core/routes/app_router.dart';
import '../../blocs/checkout/checkout_bloc.dart';
import '../../blocs/payment/payment_bloc.dart';
import '../../cubits/user/user_cubit.dart';
import '../../models/checkout_data.dart';
import '../../../domain/entity/payment/payment_method_entity.dart';
import '../../../domain/entity/payment/payment_intent_entity.dart';

class CheckoutScreen extends StatefulWidget {
  final CheckoutData? checkoutData;
  const CheckoutScreen({super.key, this.checkoutData});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _deliveryMethod = 0; // 0 for Standard, 1 for Express
  static const double _expressDeliveryFee = 15.0;
  static const String _paymentReturnUrl = 'myapp://stripe-redirect';
  PaymentMethodEntity? _selectedPaymentMethod;
  String? _handledPaymentIntentId;

  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(const LoadPaymentMethodsEvent());
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = widget.checkoutData?.subtotal ?? 0.0;
    double shipping = widget.checkoutData?.shipping ?? 0.0;
    double expressShipping = shipping + _expressDeliveryFee;
    double total = _deliveryMethod == 1
        ? subtotal + expressShipping
        : widget.checkoutData?.total ?? subtotal + shipping;

    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, paymentState) => BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (_selectedPaymentMethod == null &&
              paymentState.paymentMethods.isNotEmpty) {
            setState(() {
              _selectedPaymentMethod = paymentState.paymentMethods.first;
            });
          }

          final paymentIntent = state.paymentIntent;
          if (paymentIntent != null &&
              !state.isPaymentLoading &&
              _handledPaymentIntentId != paymentIntent.paymentIntentId) {
            _handledPaymentIntentId = paymentIntent.paymentIntentId;
            _handlePaymentIntent(context, paymentIntent);
          } else if (state.paymentError != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.paymentError!)));
          }
        },
        builder: (context, state) => Scaffold(
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
              onPressed: () {
                context.goNamed(AppRouter.cartName);
              },
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: Shipping Address
                _buildSectionHeader('Shipping'),
                _buildAddressCard(),
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
                  onActionTap: () async {
                    final selectedPaymentMethod = await context
                        .pushNamed<PaymentMethodEntity>(
                          AppRouter.paymentMethodName,
                          extra: widget.checkoutData,
                        );
                    if (mounted && selectedPaymentMethod != null) {
                      setState(() {
                        _selectedPaymentMethod = selectedPaymentMethod;
                      });
                    }
                  },
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
                          color:
                              context.theme.colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          (_selectedPaymentMethod?.brand ?? 'CARD')
                              .toUpperCase(),
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
                              _selectedPaymentMethod == null
                                  ? 'No payment method selected'
                                  : '${_selectedPaymentMethod!.brand ?? 'Card'} ending in ${_selectedPaymentMethod!.last4 ?? '••••'}',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                color: context.theme.colorScheme.onSurface,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedPaymentMethod == null
                                  ? 'Choose a payment method'
                                  : 'Expires ${_formatExpiry(_selectedPaymentMethod!)}',
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
                      if (_deliveryMethod == 1) ...[
                        const SizedBox(height: 12),
                        _buildSummaryRow(
                          'Delivery Fee',
                          '\$${_expressDeliveryFee.toStringAsFixed(2)}',
                        ),
                      ],

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
                        color: context.theme.colorScheme.primary.withValues(
                          alpha: 0.2,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: state.isPaymentLoading
                        ? null
                        : () {
                            context.read<CheckoutBloc>().add(
                              CreatePaymentIntentEvent(
                                total: total,
                                paymentMethodId:
                                    _selectedPaymentMethod?.paymentMethodId,
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: state.isPaymentLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
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
        ),
      ),
    );
  }

  Future<void> _handlePaymentIntent(
    BuildContext context,
    PaymentIntentEntity paymentIntent,
  ) async {
    try {
      if (paymentIntent.status == 'succeeded') {
        _showPaymentSuccess(context);
        return;
      }

      if (paymentIntent.status == 'requires_action') {
        final result = await Stripe.instance.handleNextAction(
          paymentIntent.clientSecret,
          returnURL: _paymentReturnUrl,
        );
        if (result.status == PaymentIntentsStatus.Succeeded &&
            context.mounted) {
          _showPaymentSuccess(context);
        }
        return;
      }

      if (paymentIntent.status == 'requires_payment_method') {
        await _presentPaymentSheet(context, paymentIntent.clientSecret);
        return;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Payment is not ready (status: ${paymentIntent.status})',
            ),
          ),
        );
      }
    } on StripeException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.error.localizedMessage ?? 'Payment failed'),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Payment failed: $error')));
      }
    }
  }

  Future<void> _presentPaymentSheet(
    BuildContext context,
    String clientSecret,
  ) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Atelier',
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment completed successfully')),
        );
      }
    } on StripeException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.error.localizedMessage ?? 'Payment failed'),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Payment failed: $error')));
      }
    }
  }

  void _showPaymentSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment completed successfully')),
    );
  }

  String _formatExpiry(PaymentMethodEntity card) {
    if (card.expMonth == null || card.expYear == null) {
      return 'On file';
    }
    return '${card.expMonth!.toString().padLeft(2, '0')}/${card.expYear! % 100}';
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
                      : context.theme.colorScheme.outline.withValues(
                          alpha: 0.4,
                        ),
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

  Widget _buildAddressCard() {
    final addressTextStyle = TextStyle(
      color: context.theme.colorScheme.secondary,
      fontSize: 13,
      height: 1.4,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          final String addressText;
          final String buttonLabel;

          if (state is UserLoading) {
            addressText = 'Loading...';
            buttonLabel = 'Loading...';
          } else if (state is UserFailure) {
            addressText = state.message;
            buttonLabel = state.message;
          } else if (state is UserLocationSuccess) {
            addressText = state.location.address.isEmpty
                ? 'No address selected yet. Tap below to select on map.'
                : state.location.address;
            buttonLabel = state.location.address.isEmpty
                ? 'Select on Map'
                : 'Edit on Map';
          } else {
            addressText =
                'No address selected yet. Tap below to select on map.';
            buttonLabel = 'Select on Map';
          }

          return Column(
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.onSurface,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(addressText, style: addressTextStyle),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.pushNamed(
                    AppRouter.pickAddressName,
                    extra: widget.checkoutData,
                  ),
                  icon: const Icon(Icons.map_outlined),
                  label: Text(buttonLabel),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
