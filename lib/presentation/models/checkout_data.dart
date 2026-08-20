import 'package:equatable/equatable.dart';

class CheckoutData extends Equatable {
  final double subtotal;
  final double shipping;
  final double total;

  const CheckoutData({
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  @override
  List<Object?> get props => [
    subtotal,
    shipping,
    total,
  ];
}