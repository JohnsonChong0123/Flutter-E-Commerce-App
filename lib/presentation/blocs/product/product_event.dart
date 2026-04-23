part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  final String? category;
  final int? limit;
  final int? page;

  const LoadProducts({this.category, this.limit, this.page});

  @override
  List<Object?> get props => [category, limit, page];
}

class FilterProducts extends ProductEvent {
  final String query;
  const FilterProducts({required this.query});

  @override
  List<Object?> get props => [query];
}

class ApplyFilters extends ProductEvent {
  final bool? onSale;
  final double? minPrice;
  final double? maxPrice;

  const ApplyFilters({this.onSale, this.minPrice, this.maxPrice});

  @override
  List<Object?> get props => [onSale, minPrice, maxPrice];
}

class SortProducts extends ProductEvent {
  final SortOption option;
  const SortProducts(this.option);

  @override
  List<Object?> get props => [option];
}

class LoadProductById extends ProductEvent {
  final String productId;
  const LoadProductById(this.productId);

  @override
  List<Object?> get props => [productId];
}
