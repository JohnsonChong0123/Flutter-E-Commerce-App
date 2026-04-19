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
        ));
      } else {
        final filtered = currentState.products.where((product) {
          return product.name.toLowerCase().startsWith(query.toLowerCase());
        }).toList();
        
        emit(ProductLoaded(
          products: currentState.products,
          filteredProducts: filtered,
          searchQuery: query,
        ));
      }
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
