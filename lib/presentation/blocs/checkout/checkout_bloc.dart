
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/address/address_entity.dart';


part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(const CheckoutState()) {
    on<UpdateCheckoutAddressEvent>(_onUpdateCheckoutAddress);
  }

  void _onUpdateCheckoutAddress(
    UpdateCheckoutAddressEvent event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(selectedAddress: event.address));
  }
}
