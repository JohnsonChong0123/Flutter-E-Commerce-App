import 'package:e_commerce_client/presentation/screens/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entity/address/address_entity.dart';
import '../../presentation/blocs/address/address_bloc.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/cubits/category/category_cubit.dart';
import '../../presentation/blocs/product/product_bloc.dart';
import '../../presentation/blocs/checkout/checkout_bloc.dart';
import '../../presentation/models/checkout_data.dart';
import '../../presentation/screens/account_screen.dart';
import '../../presentation/screens/address/pick_address_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/sign_up_screen.dart';
import '../../presentation/screens/cart/cart_screen.dart';
import '../../presentation/screens/checkout/checkout_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/product/product_search_screen.dart';
import '../../presentation/screens/navbar_screen.dart';
import '../../presentation/screens/product/invalid_route_screen.dart';
import '../../presentation/screens/product/product_details_screen.dart';
import '../../service_locator.dart';
import 'package:flutter/widgets.dart';

class AppRouter {
  // ---------------- Paths ----------------
  static const splash = '/';
  static const login = '/login';
  static const signUp = '/signUp';
  static const home = '/home';
  static const productDetails = '/productDetails/:id';
  static const cart = '/cart';
  static const wishlist = '/wishlist';
  static const account = '/account';
  static const productSearch = '/productSearch';
  static const checkout = '/checkout';
  static const pickAddress = '/pickAddress';
  static const addressesList = '/addressesList';

  // ---------------- Names ----------------
  static const splashName = 'splash';
  static const loginName = 'login';
  static const signUpName = 'signUp';
  static const homeName = 'home';
  static const productDetailsName = 'productDetails';
  static const cartName = 'cart';
  static const wishlistName = 'wishlist';
  static const accountName = 'account';
  static const productSearchName = 'productSearch';
  static const checkoutName = 'checkout';
  static const pickAddressName = 'pickAddress';
  static const addressesListName = 'addressesList';

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter router(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: splash,
      observers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      navigatorKey: _rootNavigatorKey,
      routes: [
        GoRoute(
          path: splash,
          name: splashName,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: login,
          name: loginName,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: signUp,
          name: signUpName,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: productDetails,
          name: productDetailsName,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id'];
            if (id == null) return const InvalidRouteScreen();

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      ProductBloc(getProducts: sl(), getProductById: sl())
                        ..loadProductById(id),
                ),
              ],
              child: ProductDetailScreen(productId: id),
            );
          },
        ),
        GoRoute(
          path: checkout,
          name: checkoutName,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final checkoutData = state.extra as CheckoutData?;

            return BlocProvider(
              create: (_) => sl<CheckoutBloc>(),
              child: CheckoutScreen(checkoutData: checkoutData),
            );
          },
        ),
        GoRoute(
          path: pickAddress,
          name: pickAddressName,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final initialAddress = state.extra is AddressEntity
                ? state.extra as AddressEntity
                : null;

            return BlocProvider(
              create: (_) => sl<AddressPickerBloc>(),
              child: AddressPickerPage(initialAddress: initialAddress),
            );
          },
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return NavBarScreen(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _shellNavigatorKey,
              routes: [
                GoRoute(
                  path: home,
                  name: homeName,
                  builder: (context, state) => BlocProvider(
                    create: (context) =>
                        ProductBloc(getProducts: sl(), getProductById: sl()),
                    child: const HomeScreen(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: productSearch,
                  name: productSearchName,
                  builder: (context, state) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => ProductBloc(
                            getProducts: sl(),
                            getProductById: sl(),
                          ),
                        ),
                        BlocProvider(create: (context) => CategoryCubit()),
                      ],
                      child: const ProductSearchScreen(),
                    );
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: cart,
                  name: cartName,
                  builder: (context, state) => const CartScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: account,
                  name: accountName,
                  builder: (context, state) => const AccountScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
