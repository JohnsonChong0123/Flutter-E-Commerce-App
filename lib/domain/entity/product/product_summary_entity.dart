import 'package:equatable/equatable.dart';

import '../shipping/money_entity.dart';

class ProductSummaryEntity extends Equatable {
  final String id;
  final String name;
  final MoneyEntity? initialPrice;
  final MoneyEntity? finalPrice;
  final String imageUrl;

  const ProductSummaryEntity({
    required this.id,
    required this.name,
    required this.initialPrice,
    required this.finalPrice,
    required this.imageUrl,
  });

  bool get hasDiscount => finalPrice != null && initialPrice != null && finalPrice!.value < initialPrice!.value;

  @override
  List<Object?> get props => [
    id,
    name,
    initialPrice,
    finalPrice,
    imageUrl,
  ];
}
