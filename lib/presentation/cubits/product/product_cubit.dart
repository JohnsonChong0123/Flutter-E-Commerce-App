import 'package:e_commerce_client/domain/entity/product/product_details_entity.dart';
import 'package:e_commerce_client/domain/usecases/product/get_product_by_id.dart';
import '../../../domain/entity/product/product_summary_entity.dart';
import '../../../domain/usecases/product/get_products.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts _getProducts;
  final GetProductById _getProductById;

  ProductCubit({required GetProducts getProducts, required GetProductById getProductById})
    : _getProducts = getProducts,
      _getProductById = getProductById,
      super(ProductInitial());

  Future<void> loadProducts() async {
    emit(const ProductLoading());
    final result = await _getProducts(NoParams());
    result.fold(
      (failure) => emit(ProductFailure(message: failure.message)),
      (products) => emit(ProductLoaded(products: products)),
    );
  }

  Future<void> loadProductById(String productId) async {
    emit(const ProductLoading());
    final result = await _getProductById(GetProductByIdParams(productId: productId));
    result.fold(
      (failure) => emit(ProductFailure(message: failure.message)),
      (product) => emit(ProductDetailsLoaded(product: product)),
    );
  }
}
