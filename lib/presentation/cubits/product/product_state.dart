part of 'product_cubit.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {
  const ProductLoading();
}

final class ProductLoaded extends ProductState {
  final List<ProductSummaryEntity> products;

  const ProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

final class ProductDetailsLoaded extends ProductState {
  final ProductDetailsEntity product;

  const ProductDetailsLoaded({required this.product});

  @override
  List<Object> get props => [product];
}

final class ProductFailure extends ProductState {
  final String message;

  const ProductFailure({required this.message});

  @override
  List<Object> get props => [message];
}
