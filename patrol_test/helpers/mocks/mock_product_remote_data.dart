import 'package:e_commerce_client/data/models/product/product_details_model.dart';
import 'package:e_commerce_client/data/models/product/product_summary_model.dart';
import 'package:e_commerce_client/data/sources/remote/product_remote_data.dart';

import '../../../test/fixtures/product/product_fixtures.dart';

class MockProductRemoteData implements ProductRemoteData {
  @override
  Future<List<ProductSummaryModel>> getProducts() async {
    return tProductSummaryModelList;
  }

  @override
  Future<ProductDetailsModel> getProductById(String productId) async {
    return tProductDetailsModel;
  }
}
