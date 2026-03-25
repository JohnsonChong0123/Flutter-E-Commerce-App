import 'package:e_commerce_client/presentation/cubits/wishlist/wishlist_cubit.dart';
import 'package:e_commerce_client/presentation/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/cubits/product/product_cubit.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/sign_up_screen.dart';
import '../../presentation/screens/cart/cart_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/product/invalid_route_screen.dart';
import '../../presentation/screens/product/product_details_screen.dart';
import '../../presentation/screens/wishlist/wishlist_screen.dart';
import '../../service_locator.dart';

class AppRouter {
  // ---------------- Paths ----------------
  static const splash = '/';
  static const login = '/login';
  static const signUp = '/signUp';
  static const home = '/home';
  static const productDetails = '/productDetails/:id';
  static const cart = '/cart';
  static const wishlist = '/wishlist';

  // ---------------- Names ----------------
  static const splashName = 'splash';
  static const loginName = 'login';
  static const signUpName = 'signUp';
  static const homeName = 'home';
  static const productDetailsName = 'productDetails';
  static const cartName = 'cart';
  static const wishlistName = 'wishlist';

  static GoRouter router(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: splash,
      routes: [
        GoRoute(
          path: splash,
          name: splashName,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: login,
          name: loginName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: signUp,
          name: signUpName,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: home,
          name: homeName,
          builder: (context, state) => BlocProvider(
            create: (context) =>
                ProductCubit(getProducts: sl(), getProductById: sl()),
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: productDetails,
          name: productDetailsName,
          builder: (context, state) {
            final id = state.pathParameters['id'];
            if (id == null) return const InvalidRouteScreen();

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      ProductCubit(getProducts: sl(), getProductById: sl())
                        ..loadProductById(id),
                ),
                BlocProvider(
                  create: (context) => WishlistCubit(
                    addWishlist: sl(),
                    getWishlist: sl(),
                    removeWishlist: sl(),
                    clearWishlist: sl(),
                  ),
                ),
              ],
              child: ProductDetailScreen(productId: id),
            );
          },
        ),
        GoRoute(
          path: cart,
          name: cartName,
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: wishlist,
          name: wishlistName,
          builder: (context, state) => BlocProvider(
            create: (context) => WishlistCubit(
              addWishlist: sl(),
              getWishlist: sl(),
              removeWishlist: sl(),
              clearWishlist: sl(),
            ),
            child: const WishlistScreen(),
          ),
        ),
      ],
    );
  }
}
