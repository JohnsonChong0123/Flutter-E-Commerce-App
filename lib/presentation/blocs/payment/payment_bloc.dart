import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';
import '../../../domain/entity/payment/payment_method_entity.dart';
import '../../../domain/entity/payment/setup_intent_entity.dart';
import '../../../domain/usecases/payment/create_setup_intent.dart';
import '../../../domain/usecases/payment/get_payment_methods.dart';
import '../../../domain/usecases/payment/get_setup_intent.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreateSetupIntent? _createSetupIntent;
  final GetSetupIntent? _getSetupIntent;
  final GetPaymentMethods? _getPaymentMethods;

  PaymentBloc({
    CreateSetupIntent? createSetupIntent,
    GetSetupIntent? getSetupIntent,
    GetPaymentMethods? getPaymentMethods,
  }) : _createSetupIntent = createSetupIntent,
       _getSetupIntent = getSetupIntent,
       _getPaymentMethods = getPaymentMethods,
       super(const PaymentState()) {
    on<LoadPaymentMethodsEvent>(_onLoadPaymentMethods);
    on<CreateSetupIntentEvent>(_onCreateSetupIntent);
    on<VerifySetupIntentEvent>(_onVerifySetupIntent);
  }

  Future<void> _onLoadPaymentMethods(
    LoadPaymentMethodsEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(
      PaymentState(
        setupIntent: state.setupIntent,
        isSetupIntentLoading: state.isSetupIntentLoading,
        setupIntentError: state.setupIntentError,
        paymentMethods: state.paymentMethods,
        isPaymentMethodsLoading: true,
      ),
    );

    if (_getPaymentMethods == null) {
      emit(
        PaymentState(
          setupIntent: state.setupIntent,
          isSetupIntentLoading: state.isSetupIntentLoading,
          setupIntentError: state.setupIntentError,
          paymentMethods: state.paymentMethods,
          paymentMethodsError: 'Payment is not configured',
        ),
      );
      return;
    }

    final result = await _getPaymentMethods(NoParams());
    result.fold(
      (failure) => emit(
        PaymentState(
          setupIntent: state.setupIntent,
          isSetupIntentLoading: state.isSetupIntentLoading,
          setupIntentError: state.setupIntentError,
          paymentMethods: state.paymentMethods,
          paymentMethodsError: failure.message,
        ),
      ),
      (paymentMethods) => emit(
        PaymentState(
          setupIntent: state.setupIntent,
          isSetupIntentLoading: state.isSetupIntentLoading,
          setupIntentError: state.setupIntentError,
          paymentMethods: paymentMethods,
        ),
      ),
    );
  }

  Future<void> _onCreateSetupIntent(
    CreateSetupIntentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(
      PaymentState(
        setupIntent: state.setupIntent,
        isSetupIntentLoading: true,
        paymentMethods: state.paymentMethods,
        isPaymentMethodsLoading: state.isPaymentMethodsLoading,
        paymentMethodsError: state.paymentMethodsError,
      ),
    );

    if (_createSetupIntent == null) {
      emit(
        PaymentState(
          setupIntent: state.setupIntent,
          paymentMethods: state.paymentMethods,
          isPaymentMethodsLoading: state.isPaymentMethodsLoading,
          paymentMethodsError: state.paymentMethodsError,
          setupIntentError: 'Payment is not configured',
        ),
      );
      return;
    }

    final result = await _createSetupIntent(
      CreateSetupIntentParams(customerId: event.customerId),
    );
    result.fold(
      (failure) => emit(
        PaymentState(
          setupIntent: state.setupIntent,
          setupIntentError: failure.message,
          paymentMethods: state.paymentMethods,
          isPaymentMethodsLoading: state.isPaymentMethodsLoading,
          paymentMethodsError: state.paymentMethodsError,
        ),
      ),
      (setupIntent) => emit(
        PaymentState(
          setupIntent: setupIntent,
          paymentMethods: state.paymentMethods,
          isPaymentMethodsLoading: state.isPaymentMethodsLoading,
          paymentMethodsError: state.paymentMethodsError,
        ),
      ),
    );
  }

  Future<void> _onVerifySetupIntent(
    VerifySetupIntentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    if (_getSetupIntent == null) {
      emit(
        PaymentState(
          setupIntent: state.setupIntent,
          setupIntentError: 'Payment is not configured',
          paymentMethods: state.paymentMethods,
          isPaymentMethodsLoading: state.isPaymentMethodsLoading,
          paymentMethodsError: state.paymentMethodsError,
        ),
      );
      return;
    }

    emit(
      PaymentState(
        setupIntent: state.setupIntent,
        isSetupIntentLoading: true,
        paymentMethods: state.paymentMethods,
        isPaymentMethodsLoading: state.isPaymentMethodsLoading,
        paymentMethodsError: state.paymentMethodsError,
      ),
    );
    final result = await _getSetupIntent(
      GetSetupIntentParams(event.setupIntentId),
    );
    result.fold(
      (failure) => emit(
        PaymentState(
          setupIntent: state.setupIntent,
          setupIntentError: failure.message,
          paymentMethods: state.paymentMethods,
          isPaymentMethodsLoading: state.isPaymentMethodsLoading,
          paymentMethodsError: state.paymentMethodsError,
        ),
      ),
      (setupIntent) => emit(
        PaymentState(
          setupIntent: setupIntent,
          paymentMethods: state.paymentMethods,
          isPaymentMethodsLoading: state.isPaymentMethodsLoading,
          paymentMethodsError: state.paymentMethodsError,
        ),
      ),
    );
  }
}
