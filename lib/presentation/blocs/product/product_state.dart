part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {
  const ProductLoading();
}

enum SortOption { none, priceAsc, priceDesc, nameAsc, nameDesc }

class ProductLoaded extends ProductState {
  final List<ProductSummaryEntity> products;
  final List<ProductSummaryEntity> filteredProducts;
  final String? searchQuery;
  final SortOption? sortOption;

  const ProductLoaded({
    required this.products,
    this.filteredProducts = const [],
    this.searchQuery,
    this.sortOption,
  });

  @override
  List<Object?> get props => [products, filteredProducts, searchQuery, sortOption];
}

final class ProductDetailsLoaded extends ProductState {
  final ProductDetailsEntity product;
  final List<ProductDisplayAspect> aspect;
  final List<ProductDisplayAspect> shippingAspects;

  const ProductDetailsLoaded({required this.product, required this.aspect, required this.shippingAspects});

  @override
  List<Object> get props => [product, aspect, shippingAspects];
}

final class ProductFailure extends ProductState {
  final String message;

  const ProductFailure({required this.message});

  @override
  List<Object> get props => [message];
}
