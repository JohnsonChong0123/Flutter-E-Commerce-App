import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/models/auth_response.dart';
import 'package:e_commerce_client/data/models/user_model.dart';
import 'package:e_commerce_client/data/sources/remote/auth_remote_data.dart';

/// Base class: All methods preset to throw UnimplementedError，
/// getCurrentUser set throw ServerException（Unauthenticated）
abstract class MockAuthRemoteDataBase implements AuthRemoteData {
  @override
  Future<UserModel> getCurrentUser() async =>
      throw ServerException('Unauthorized');

  @override
  Future<AuthResponse> loginWithEmailPassword({
    required String email,
    required String password,
  }) async => throw UnimplementedError();

  @override
  Future<AuthResponse> loginWithGoogle() async => throw UnimplementedError();

  @override
  Future<AuthResponse> loginWithFacebook() async => throw UnimplementedError();

  @override
  Future<void> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async => throw UnimplementedError();

  @override
  Future<String?> refreshToken(String? refreshToken) async => null;
}

// ── Unauthenticated ──────────────────────────────────────────────────────────

/// getCurrentUser throws ServerException → AuthUnauthenticated
class MockAuthRemoteDataUnauthenticated extends MockAuthRemoteDataBase {}

// ── Authenticated ────────────────────────────────────────────────────────────

/// getCurrentUser returns UserModel → AuthAuthenticated
class MockAuthRemoteDataAuthenticated extends MockAuthRemoteDataBase {
  @override
  Future<UserModel> getCurrentUser() async => UserModel(
        userId: 'test-id',
        firstName: 'Test',
        lastName: 'User',
        email: 'test@example.com',
        phone: '012-3456789',
        image: '',
      );
}

// ── Sign Up ──────────────────────────────────────────────────────────────────

/// signUpWithEmailPassword succeeds (void)
class MockAuthRemoteDataSignUp extends MockAuthRemoteDataBase {
  @override
  Future<void> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async => Future.delayed(const Duration(seconds: 1));
}

// ── Login ────────────────────────────────────────────────────────────────────

/// loginWithEmailPassword returns AuthResponse → AuthAuthenticated
class MockAuthRemoteDataLogin extends MockAuthRemoteDataBase {
  @override
  Future<AuthResponse> loginWithEmailPassword({
    required String email,
    required String password,
  }) async => AuthResponse(
        accessToken: 'fake-access-token',
        refreshToken: 'fake-refresh-token',
        provider: 'email',
        user: UserModel(
          userId: 'test-id',
          firstName: 'Test',
          lastName: 'User',
          email: email,
          phone: '012-3456789',
          image: '',
        ),
      );
}

// ── Google Login ─────────────────────────────────────────────────────────────

/// loginWithGoogle returns AuthResponse → AuthAuthenticated
class MockAuthRemoteDataLoginWithGoogle extends MockAuthRemoteDataBase {
  @override
  Future<AuthResponse> loginWithGoogle() async => AuthResponse(
        accessToken: 'fake-google-access-token',
        refreshToken: 'fake-google-refresh-token',
        provider: 'google',
        user: UserModel(
          userId: 'google-test-id',
          firstName: 'Google',
          lastName: 'User',
          email: 'google.user@example.com',
          phone: '012-3456789',
          image: '',
        ),
      );
}

// ── Facebook Login ───────────────────────────────────────────────────────────

/// loginWithFacebook returns AuthResponse → AuthAuthenticated
class MockAuthRemoteDataLoginWithFacebook extends MockAuthRemoteDataBase {
  @override
  Future<AuthResponse> loginWithFacebook() async => AuthResponse(
        accessToken: 'fake-facebook-access-token',
        refreshToken: 'fake-facebook-refresh-token',
        provider: 'facebook',
        user: UserModel(
          userId: 'facebook-test-id',
          firstName: 'Facebook',
          lastName: 'User',
          email: 'facebook.user@example.com',
          phone: '012-3456789',
          image: '',
        ),
      );
}