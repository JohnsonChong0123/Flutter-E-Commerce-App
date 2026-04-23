import 'package:e_commerce_client/domain/entity/product/product_details_entity.dart';
import 'package:e_commerce_client/domain/usecases/product/get_product_by_id.dart';
import '../../../domain/entity/product/product_summary_entity.dart';
import '../../../domain/usecases/product/get_products.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts _getProducts;
  final GetProductById _getProductById;

  ProductCubit({
    required GetProducts getProducts,
    required GetProductById getProductById,
  }) : _getProducts = getProducts,
       _getProductById = getProductById,
       super(ProductInitial());

  Future<void> loadProducts({String? category, int? limit, int? page}) async {
    emit(const ProductLoading());
    final result = await _getProducts(GetProductsParams(
      category: category,
      limit: limit,
      page: page,
    ));

    result.fold(
      (failure) => emit(ProductFailure(message: failure.message)),
      (products) => emit(ProductLoaded(
        products: products, 
        filteredProducts: products,
        sortOption: SortOption.none,
      )),
    );
  }

  void filterProducts(String query) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      
      if (query.isEmpty) {
        emit(ProductLoaded(
          products: currentState.products,
          filteredProducts: currentState.products,
          searchQuery: query,
          sortOption: currentState.sortOption,
        ));
      } else {
        final filtered = currentState.products.where((product) {
          return product.name.toLowerCase().startsWith(query.toLowerCase());
        }).toList();
        
        emit(ProductLoaded(
          products: currentState.products,
          filteredProducts: filtered,
          searchQuery: query,
          sortOption: currentState.sortOption,
        ));
      }
    }
  }

  void applyFilters({bool? onSale, double? minPrice, double? maxPrice}) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final baseProducts = currentState.products;
      final searchQuery = currentState.searchQuery ?? '';

      final filtered = baseProducts.where((product) {
        if (searchQuery.isNotEmpty && !product.name.toLowerCase().startsWith(searchQuery.toLowerCase())) {
          return false;
        }

        if (onSale == true && !product.hasDiscount) return false;

        if (minPrice != null && product.finalPrice < minPrice) return false;
        if (maxPrice != null && product.finalPrice > maxPrice) return false;

        return true;
      }).toList();

      emit(ProductLoaded(
        products: currentState.products,
        filteredProducts: filtered,
        searchQuery: currentState.searchQuery,
        sortOption: currentState.sortOption,
      ));
    }
  }

  void sortProducts(SortOption option) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final List<ProductSummaryEntity> baseList = currentState.filteredProducts.isNotEmpty
          ? List<ProductSummaryEntity>.from(currentState.filteredProducts)
          : List<ProductSummaryEntity>.from(currentState.products);

      switch (option) {
        case SortOption.priceAsc:
          baseList.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
          break;
        case SortOption.priceDesc:
          baseList.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
          break;
        case SortOption.nameAsc:
          baseList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          break;
        case SortOption.nameDesc:
          baseList.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
          break;
        case SortOption.none:
          final baseProducts = currentState.products;
          final searchQuery = currentState.searchQuery ?? '';
          final reFiltered = baseProducts.where((product) {
            if (searchQuery.isNotEmpty && !product.name.toLowerCase().startsWith(searchQuery.toLowerCase())) return false;
            return true;
          }).toList();
          baseList
            ..clear()
            ..addAll(reFiltered);
          break;
      }

      emit(ProductLoaded(
        products: currentState.products,
        filteredProducts: baseList,
        searchQuery: currentState.searchQuery,
        sortOption: option,
      ));
    }
  }

  Future<void> loadProductById(String productId) async {
    emit(const ProductLoading());
    final result = await _getProductById(
      GetProductByIdParams(productId: productId),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(ProductFailure(message: failure.message)),
      (product) => emit(ProductDetailsLoaded(product: product)),
    );
  }
}
