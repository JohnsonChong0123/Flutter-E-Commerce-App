import 'package:equatable/equatable.dart';

class ProductDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double finalPrice;
  final String imageUrl;

  const ProductDetailsEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.finalPrice,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    finalPrice,
    imageUrl,
  ];
}
