import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/address/address_entity.dart';
import '../../../domain/entity/payment/payment_intent_entity.dart';
import '../../../domain/usecases/payment/create_payment_intent.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CreatePaymentIntent? _createPaymentIntent;

  CheckoutBloc({CreatePaymentIntent? createPaymentIntent})
    : _createPaymentIntent = createPaymentIntent,
      super(const CheckoutState()) {
    on<UpdateCheckoutAddressEvent>(_onUpdateCheckoutAddress);
    on<CreatePaymentIntentEvent>(_onCreatePaymentIntent);
  }

  void _onUpdateCheckoutAddress(
    UpdateCheckoutAddressEvent event,
    Emitter<CheckoutState> emit,
  ) {
    emit(
      CheckoutState(
        selectedAddress: event.address,
        paymentIntent: state.paymentIntent,
        isPaymentLoading: state.isPaymentLoading,
        paymentError: state.paymentError,
      ),
    );
  }

  Future<void> _onCreatePaymentIntent(
    CreatePaymentIntentEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(
      CheckoutState(
        selectedAddress: state.selectedAddress,
        paymentIntent: state.paymentIntent,
        isPaymentLoading: true,
      ),
    );

    if (_createPaymentIntent == null) {
      emit(
        CheckoutState(
          selectedAddress: state.selectedAddress,
          paymentIntent: state.paymentIntent,
          paymentError: 'Payment is not configured',
        ),
      );
      return;
    }

    final result = await _createPaymentIntent(
      CreatePaymentIntentParams(
        amount: (event.total * 100).round(),
        currency: event.currency,
        paymentMethodId: event.paymentMethodId,
      ),
    );

    result.fold(
      (failure) => emit(
        CheckoutState(
          selectedAddress: state.selectedAddress,
          paymentIntent: state.paymentIntent,
          paymentError: failure.message,
        ),
      ),
      (paymentIntent) => emit(
        CheckoutState(
          selectedAddress: state.selectedAddress,
          paymentIntent: paymentIntent,
        ),
      ),
    );
  }
}
