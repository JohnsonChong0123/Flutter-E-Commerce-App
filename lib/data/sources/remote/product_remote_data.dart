import 'package:dio/dio.dart';

import '../../../core/errors/exception.dart';
import '../../models/product/product_details_model.dart';
import '../../models/product/product_summary_model.dart';

abstract interface class ProductRemoteData {
  Future<List<ProductSummaryModel>> getProducts();

  Future<ProductDetailsModel> getProductById(String productId);
}

class ProductRemoteDataImpl implements ProductRemoteData {
  final Dio dio;

  ProductRemoteDataImpl({required this.dio});

  @override
  Future<List<ProductSummaryModel>> getProducts() async {
    try {
      final response = await dio.get('/products');
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
      final response = await dio.get('/products/$productId');
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
