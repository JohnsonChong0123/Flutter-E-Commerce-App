import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../models/checkout_data.dart';
import '../../blocs/payment/payment_bloc.dart';
import '../../../domain/entity/payment/payment_method_entity.dart';
import '../../../domain/entity/payment/setup_intent_entity.dart';

class PaymentMethodScreen extends StatefulWidget {
  final CheckoutData? checkoutData;
  const PaymentMethodScreen({super.key, this.checkoutData});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _openingSetupIntentId;

  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(const LoadPaymentMethodsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;

    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        final setupIntent = state.setupIntent;
        if (state.setupIntentError != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.setupIntentError!)));
        }

        if (setupIntent != null &&
            setupIntent.status != 'succeeded' &&
            !state.isSetupIntentLoading &&
            _openingSetupIntentId != setupIntent.setupIntentId) {
          _openSetupPaymentSheet(context, setupIntent);
        }

        if (setupIntent?.status == 'succeeded' &&
            _openingSetupIntentId == setupIntent?.setupIntentId) {
          _openingSetupIntentId = null;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment method saved successfully')),
          );
          context.read<PaymentBloc>().add(const LoadPaymentMethodsEvent());
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
          backgroundColor: colors.surfaceContainerLow,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SETTINGS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: colors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Payments',
                  style: GoogleFonts.manrope(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 32),

                // Wallet section
                // Text(
                //   'ATELIER WALLET',
                //   style: GoogleFonts.manrope(
                //     fontSize: 11,
                //     fontWeight: FontWeight.w800,
                //     letterSpacing: 2.0,
                //     color: colors.secondary,
                //   ),
                // ),
                // const SizedBox(height: 12),
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.all(24),
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [colors.primary, colors.primaryContainer],
                //     ),
                //     borderRadius: BorderRadius.circular(16),
                //     boxShadow: [
                //       BoxShadow(
                //         color: colors.primary.withValues(alpha: 0.2),
                //         blurRadius: 20,
                //         offset: const Offset(0, 10),
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Atelier Credit',
                //         style: GoogleFonts.plusJakartaSans(
                //           color: Colors.white70,
                //           fontSize: 13,
                //         ),
                //       ),
                //       const SizedBox(height: 4),
                //       Text(
                //         '\$1,250.00',
                //         style: GoogleFonts.manrope(
                //           color: Colors.white,
                //           fontSize: 32,
                //           fontWeight: FontWeight.w800,
                //           letterSpacing: -0.5,
                //         ),
                //       ),
                //       const SizedBox(height: 24),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             'Lumière Pay Active',
                //             style: GoogleFonts.plusJakartaSans(
                //               color: Colors.white70,
                //               fontSize: 12,
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //           const Icon(
                //             Icons.circle,
                //             color: Colors.greenAccent,
                //             size: 8,
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 40),

                // Saved methods list
                Text(
                  'SAVED METHODS',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                    color: colors.secondary,
                  ),
                ),
                const SizedBox(height: 12),
                if (state.isPaymentMethodsLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state.paymentMethods.isEmpty)
                  Text(
                    'No saved payment methods',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: colors.secondary,
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.paymentMethods.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final card = state.paymentMethods[index];
                      return InkWell(
                        onTap: () => Navigator.of(context).pop(card),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  (card.brand ?? 'Card').toUpperCase(),
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w800,
                                    color: colors.primary,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${card.brand ?? 'Card'} ending in ${card.last4 ?? '••••'}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: colors.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Expires ${_formatExpiry(card)}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: colors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: colors.secondary,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 24),

                // Add Card option
                OutlinedButton.icon(
                  onPressed: state.isSetupIntentLoading
                      ? null
                      : () => context.read<PaymentBloc>().add(
                          const CreateSetupIntentEvent(),
                        ),
                  icon: Icon(Icons.add, color: colors.onSurface),
                  label: Text(
                    'Add Payment Method',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    side: BorderSide(color: colors.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Secure note
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.lock_outline, color: colors.outline, size: 20),
                      const SizedBox(height: 8),
                      Text(
                        'Secure & Encrypted',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your credentials are stored using military-grade AES-256 encryption. We never share your transaction logs.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: colors.secondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatExpiry(PaymentMethodEntity card) {
    if (card.expMonth == null || card.expYear == null) {
      return 'On file';
    }
    return '${card.expMonth!.toString().padLeft(2, '0')}/${card.expYear! % 100}';
  }

  Future<void> _openSetupPaymentSheet(
    BuildContext context,
    SetupIntentEntity setupIntent,
  ) async {
    _openingSetupIntentId = setupIntent.setupIntentId;
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: setupIntent.clientSecret,
          merchantDisplayName: 'Atelier',
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      if (context.mounted) {
        context.read<PaymentBloc>().add(
          VerifySetupIntentEvent(setupIntent.setupIntentId),
        );
      }
    } on StripeException catch (error) {
      _openingSetupIntentId = null;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.error.localizedMessage ?? 'Payment failed'),
          ),
        );
      }
    } catch (error) {
      _openingSetupIntentId = null;
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Payment failed: $error')));
      }
    }
  }
}
