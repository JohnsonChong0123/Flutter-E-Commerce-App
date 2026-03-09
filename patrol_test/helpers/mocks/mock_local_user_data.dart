import 'package:e_commerce_client/data/sources/local/user_local_data.dart';

class MockUserLocalData implements UserLocalData {
  String? _accessToken;
  String? _refreshToken;
  String? _provider;
  
  MockUserLocalData({
    String? accessToken,
    String? refreshToken,
    String? provider,
  })  : _accessToken = accessToken,
        _refreshToken = refreshToken,
        _provider = provider;

  @override
  Future<void> saveAuth({
    required String accessToken,
    required String refreshToken,
    required String provider,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _provider = provider;
  }

  @override
  Future<String?> getAccessToken() async => _accessToken;

  @override
  Future<String?> getRefreshToken() async => _refreshToken;

  @override
  Future<void> setAccessToken(String accessToken) async {
    _accessToken = accessToken;
  }
}