import 'package:dio/dio.dart';
import 'package:e_commerce_client/domain/usecases/product/get_products.dart';

import '../../../core/errors/exception.dart';
import '../../models/product/product_details_model.dart';
import '../../models/product/product_summary_model.dart';

abstract interface class ProductRemoteData {
  Future<List<ProductSummaryModel>> getProducts(GetProductsParams params);

  Future<ProductDetailsModel> getProductById(String productId);
}

class ProductRemoteDataImpl implements ProductRemoteData {
  final Dio dio;

  ProductRemoteDataImpl({required this.dio});

  @override
  Future<List<ProductSummaryModel>> getProducts(GetProductsParams params) async {
    try {
      final response = await dio.get(
        '/product/list-products',
        queryParameters: {
        if (params.category != null) 'q': params.category,
        if (params.limit != null) 'limit': params.limit,
        if (params.page != null) 'page': params.page,
      },
      );
      return (response.data as List)
          .map((json) => ProductSummaryModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final error = e.error;
      if (error is ServerException) {
        throw error;
      }
      throw ServerException('An unexpected error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<ProductDetailsModel> getProductById(String productId) async {
    try {
      final response = await dio.get('/product/$productId');
      return ProductDetailsModel.fromJson(response.data);
    } on DioException catch (e) {
      final error = e.error;
      if (error is ServerException) {
        throw error;
      }
      throw ServerException('An unexpected error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
