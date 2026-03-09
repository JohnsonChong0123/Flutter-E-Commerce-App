import 'package:e_commerce_client/core/network/dio_client.dart';
import 'package:e_commerce_client/data/repositories/auth_repository_impl.dart';
import 'package:e_commerce_client/data/repositories/cart_repository_impl.dart';
import 'package:e_commerce_client/data/repositories/product_repository_impl.dart';
import 'package:e_commerce_client/data/sources/local/user_local_data.dart';
import 'package:e_commerce_client/data/sources/remote/auth_remote_data.dart';
import 'package:e_commerce_client/data/sources/remote/cart_remote_data.dart';
import 'package:e_commerce_client/data/sources/remote/product_remote_data.dart';
import 'package:e_commerce_client/domain/repositories/auth_repository.dart';
import 'package:e_commerce_client/domain/repositories/cart_repository.dart';
import 'package:e_commerce_client/domain/repositories/product_repository.dart';
import 'package:e_commerce_client/domain/usecases/auth/check_auth_status.dart';
import 'package:e_commerce_client/domain/usecases/auth/facebook_login.dart';
import 'package:e_commerce_client/domain/usecases/auth/google_login.dart';
import 'package:e_commerce_client/domain/usecases/auth/login.dart';
import 'package:e_commerce_client/domain/usecases/auth/sign_up.dart';
import 'package:e_commerce_client/domain/usecases/cart/add_to_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/clear_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/get_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/remove_cart_item.dart';
import 'package:e_commerce_client/domain/usecases/product/get_product_by_id.dart';
import 'package:e_commerce_client/domain/usecases/product/get_products.dart';
import 'package:e_commerce_client/presentation/blocs/auth/auth_bloc.dart';
import 'package:e_commerce_client/presentation/cubits/cart/cart_cubit.dart';
import 'package:e_commerce_client/presentation/cubits/product/product_cubit.dart';
import 'package:e_commerce_client/service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../mocks/mock_auth_remote_data.dart';
import '../mocks/mock_local_user_data.dart';
import '../mocks/mock_product_remote_data.dart';

Future<void> initTestServiceLocator({
  AuthRemoteData? authRemoteData,
  ProductRemoteData? productRemoteData,
}) async {
  sl.allowReassignment = true;
  await sl.reset();

  if (!dotenv.isInitialized) {
    await dotenv.load(fileName: '.env');
  }

  // Auth
  sl
    ..registerLazySingleton<AuthRemoteData>(
      () => authRemoteData ?? MockAuthRemoteDataUnauthenticated(),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteData: sl(), userLocalData: sl()),
    )
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => Login(sl()))
    ..registerLazySingleton(() => GoogleLogin(sl()))
    ..registerLazySingleton(() => FacebookLogin(sl()))
    ..registerLazySingleton(() => CheckAuthStatus(sl()))
    ..registerFactory(
      () => AuthBloc(
        signUp: sl(),
        login: sl(),
        googleLogin: sl(),
        facebookLogin: sl(),
        checkAuthStatus: sl(),
      ),
    );

  sl.registerLazySingleton<UserLocalData>(() => MockUserLocalData());

  // Product
  sl
    ..registerLazySingleton<ProductRemoteData>(
      () => productRemoteData ?? MockProductRemoteData(),
    )
    ..registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(productRemoteData: sl()),
    )
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerLazySingleton(() => GetProductById(sl()))
    ..registerFactory(
      () => ProductCubit(getProducts: sl(), getProductById: sl()),
    );

  // Cart
  sl
    ..registerLazySingleton<CartRemoteData>(() => CartRemoteDataImpl(dio: sl()))
    ..registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(cartRemoteData: sl()),
    )
    ..registerLazySingleton(() => AddToCart(sl()))
    ..registerLazySingleton(() => GetCart(sl()))
    ..registerLazySingleton(() => RemoveCartItem(sl()))
    ..registerLazySingleton(() => ClearCart(sl()))
    ..registerFactory(
      () => CartCubit(
        addToCart: sl(),
        getCart: sl(),
        removeCartItem: sl(),
        clearCart: sl(),
      ),
    );

  // DioClient
  sl
    ..registerLazySingleton(
      () => DioClient(
        userLocalData: sl(),
        getAuthRemoteData: () => sl<AuthRemoteData>(),
      ),
    )
    ..registerLazySingleton(() => sl<DioClient>().dio);
}
