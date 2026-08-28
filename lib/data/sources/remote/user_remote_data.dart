import 'package:dio/dio.dart';
import '../../../core/errors/exception.dart';
import '../../models/location_model.dart';

abstract interface class UserRemoteData {
  Future<void> updateUserAddress({
    required String address,
    required double latitude,
    required double longitude,
  });

  Future<LocationModel> getUserLocation();
}

class UserRemoteDataImpl implements UserRemoteData {
  final Dio dio;
  UserRemoteDataImpl({required this.dio});
  @override
  Future<void> updateUserAddress({
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await dio.put(
        '/user/me/address',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          extra: {'requiredAuth': true},
        ),
        data: {
          "user_address": address,
          "user_latitude": latitude,
          "user_longitude": longitude,
        },
      );
    } catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<LocationModel> getUserLocation() async {
    try {
      final response = await dio.get(
        '/user/me/location',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          extra: {'requiredAuth': true},
        ),
      );
      return LocationModel.fromJson(response.data);
    } catch (e) {
       _handleError(e);
    }
  }

  Never _handleError(Object e) {
    if (e is DioException && e.error is ServerException) {
      throw e.error as ServerException;
    }
    if (e is DioException) {
      throw ServerException('An unexpected error occurred');
    }
    throw ServerException(e.toString());
  }
}
