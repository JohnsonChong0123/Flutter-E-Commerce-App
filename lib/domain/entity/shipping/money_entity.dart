import 'package:equatable/equatable.dart';

class MoneyEntity extends Equatable {
  final String currency;
  final double value;

  const MoneyEntity({required this.currency, required this.value});

  @override
  List<Object?> get props => [currency, value];
}