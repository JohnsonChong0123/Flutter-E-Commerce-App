import 'package:equatable/equatable.dart';

class ProductDisplayAspect extends Equatable {
  final String name;
  final String value;

  const ProductDisplayAspect({required this.name, required this.value});

  @override
  List<Object?> get props => [name, value];
}