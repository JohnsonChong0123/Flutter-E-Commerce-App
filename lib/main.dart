import 'dart:ui';

import 'package:e_commerce_client/app_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'core/routes/app_router.dart';
import 'core/themes/app_theme.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/cubits/wishlist/wishlist_cubit.dart';
import 'service_locator.dart';

bool isTestMode = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Bloc.observer = AppBlocObserver();

  if (!isTestMode) {
    await dotenv.load();
    await initServiceLocator();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(const AuthCheckStatus()),
        ),
        BlocProvider(
          create: (_) => sl<CartBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<WishlistCubit>(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    _router = AppRouter.router(authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        final currentLocation =
            _router.routerDelegate.currentConfiguration.uri.path;

        if (state is AuthUnauthenticated) {
          if (currentLocation != AppRouter.login && currentLocation != AppRouter.signUp) {
            _router.goNamed(AppRouter.loginName);
          }
        } else if (state is AuthAuthenticated) {
          if (currentLocation == AppRouter.splash ||
              currentLocation == AppRouter.login ||
              currentLocation == AppRouter.signUp) {
            _router.goNamed(AppRouter.homeName);
          }
        }
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
