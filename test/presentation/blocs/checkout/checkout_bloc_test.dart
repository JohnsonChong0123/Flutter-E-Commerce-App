import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/domain/entity/address/address_entity.dart';
import 'package:e_commerce_client/presentation/blocs/checkout/checkout_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CheckoutBloc', () {
    late CheckoutBloc checkoutBloc;

    const tAddress = AddressEntity(
      latitude: 37.7749,
      longitude: -122.4194,
      formattedAddress: 'San Francisco, CA, USA',
      placeId: 'place_id_123',
    );

    const tAnotherAddress = AddressEntity(
      latitude: 40.7128,
      longitude: -74.0060,
      formattedAddress: 'New York, NY, USA',
      placeId: 'place_id_456',
    );

    setUp(() {
      checkoutBloc = CheckoutBloc();
    });

    tearDown(() {
      checkoutBloc.close();
    });

    test('initial state should be CheckoutState with null selectedAddress', () {
      expect(checkoutBloc.state, const CheckoutState(selectedAddress: null));
    });

    blocTest<CheckoutBloc, CheckoutState>(
      'should emit CheckoutState with selectedAddress when UpdateCheckoutAddressEvent is added',
      build: () => checkoutBloc,
      act: (bloc) => bloc.add(const UpdateCheckoutAddressEvent(tAddress)),
      expect: () => [CheckoutState(selectedAddress: tAddress)],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'should update selectedAddress when UpdateCheckoutAddressEvent is added with different address',
      build: () => checkoutBloc,
      seed: () => const CheckoutState(selectedAddress: tAddress),
      act: (bloc) => bloc.add(const UpdateCheckoutAddressEvent(tAnotherAddress)),
      expect: () => [CheckoutState(selectedAddress: tAnotherAddress)],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'should replace selectedAddress when UpdateCheckoutAddressEvent is added multiple times',
      build: () => checkoutBloc,
      act: (bloc) {
        bloc.add(const UpdateCheckoutAddressEvent(tAddress));
        bloc.add(const UpdateCheckoutAddressEvent(tAnotherAddress));
      },
      expect: () => [
        CheckoutState(selectedAddress: tAddress),
        CheckoutState(selectedAddress: tAnotherAddress),
      ],
    );
  });
}