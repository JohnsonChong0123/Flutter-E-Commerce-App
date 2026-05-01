import 'package:e_commerce_client/domain/entity/product/product_details_entity.dart';
import 'package:e_commerce_client/domain/usecases/product/get_product_by_id.dart';
import 'package:e_commerce_client/presentation/models/product_display_aspect.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../domain/entity/product/product_summary_entity.dart';
import '../../../domain/usecases/product/get_products.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_state.dart';
part 'product_event.dart';

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts _getProducts;
  final GetProductById _getProductById;

  ProductBloc({
    required GetProducts getProducts,
    required GetProductById getProductById,
  }) : _getProducts = getProducts,
       _getProductById = getProductById,
       super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<FilterProducts>(
      _onFilterProducts,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<ApplyFilters>(_onApplyFilters);
    on<SortProducts>(_onSortProducts);
    on<LoadProductById>(_onLoadProductById);
  }

  // Backwards-compatible public methods that dispatch events
  void loadProducts({String? category, int? limit, int? page}) =>
      add(LoadProducts(category: category, limit: limit, page: page));
  void filterProducts(String query) => add(FilterProducts(query: query));
  void applyFilters({bool? onSale, double? minPrice, double? maxPrice}) =>
      add(ApplyFilters(onSale: onSale, minPrice: minPrice, maxPrice: maxPrice));
  void sortProducts(SortOption option) => add(SortProducts(option));
  void loadProductById(String productId) => add(LoadProductById(productId));

  // Event handlers
  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await _getProducts(
      GetProductsParams(
        category: event.category,
        limit: event.limit,
        page: event.page,
      ),
    );

    result.fold(
      (failure) => emit(ProductFailure(message: failure.message)),
      (products) => emit(
        ProductLoaded(
          products: products,
          filteredProducts: products,
          sortOption: SortOption.none,
        ),
      ),
    );
  }

  void _onFilterProducts(FilterProducts event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final query = event.query;

      if (query.isEmpty) {
        emit(
          ProductLoaded(
            products: currentState.products,
            filteredProducts: currentState.products,
            searchQuery: query,
            sortOption: currentState.sortOption,
          ),
        );
      } else {
        final filtered = currentState.products.where((product) {
          return product.name.toLowerCase().startsWith(query.toLowerCase());
        }).toList();

        emit(
          ProductLoaded(
            products: currentState.products,
            filteredProducts: filtered,
            searchQuery: query,
            sortOption: currentState.sortOption,
          ),
        );
      }
    }
  }

  void _onApplyFilters(ApplyFilters event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final baseProducts = currentState.products;
      final searchQuery = currentState.searchQuery ?? '';

      final filtered = baseProducts.where((product) {
        if (searchQuery.isNotEmpty &&
            !product.name.toLowerCase().startsWith(searchQuery.toLowerCase())) {
          return false;
        }

        if (event.onSale == true && !product.hasDiscount) return false;

        if (event.minPrice != null && product.finalPrice < event.minPrice!) {
          return false;
        }
        if (event.maxPrice != null && product.finalPrice > event.maxPrice!) {
          return false;
        }

        return true;
      }).toList();

      emit(
        ProductLoaded(
          products: currentState.products,
          filteredProducts: filtered,
          searchQuery: currentState.searchQuery,
          sortOption: currentState.sortOption,
        ),
      );
    }
  }

  void _onSortProducts(SortProducts event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final List<ProductSummaryEntity> baseList =
          currentState.filteredProducts.isNotEmpty
          ? List<ProductSummaryEntity>.from(currentState.filteredProducts)
          : List<ProductSummaryEntity>.from(currentState.products);

      switch (event.option) {
        case SortOption.priceAsc:
          baseList.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
          break;
        case SortOption.priceDesc:
          baseList.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
          break;
        case SortOption.nameAsc:
          baseList.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
          break;
        case SortOption.nameDesc:
          baseList.sort(
            (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
          );
          break;
        case SortOption.none:
          final baseProducts = currentState.products;
          final searchQuery = currentState.searchQuery ?? '';
          final reFiltered = baseProducts.where((product) {
            if (searchQuery.isNotEmpty &&
                !product.name.toLowerCase().startsWith(
                  searchQuery.toLowerCase(),
                )) {
              return false;
            }
            return true;
          }).toList();
          baseList
            ..clear()
            ..addAll(reFiltered);
          break;
      }

      emit(
        ProductLoaded(
          products: currentState.products,
          filteredProducts: baseList,
          searchQuery: currentState.searchQuery,
          sortOption: event.option,
        ),
      );
    }
  }

  Future<void> _onLoadProductById(
    LoadProductById event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await _getProductById(
      GetProductByIdParams(productId: event.productId),
    );
    if (isClosed) return;
    result.fold((failure) => emit(ProductFailure(message: failure.message)), (
      productEntity,
    ) {
      final displayAspects = productEntity.localizedAspects
          .where(
            (aspect) =>
                aspect.type.toString().toLowerCase().contains('string') &&
                aspect.name.toString().trim().isNotEmpty,
          )
          .map(
            (aspect) => ProductDisplayAspect(
              name: aspect.name.toString(),
              value: aspect.value.toString(),
            ),
          )
          .toList();

      emit(
        ProductDetailsLoaded(product: productEntity, aspect: displayAspects),
      );
    });
  }
}
