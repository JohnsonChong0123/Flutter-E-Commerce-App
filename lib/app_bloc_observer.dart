import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    final String eventName = event.runtimeType.toString();
    final String blocName = bloc.runtimeType.toString();

    FirebaseCrashlytics.instance.log('▶️ [BLoC Event] $blocName -> $eventName');

    FirebaseAnalytics.instance.logEvent(
      name: 'user_bloc_action',
      parameters: {'bloc_layer': blocName, 'event_action': eventName},
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    final String blocName = bloc.runtimeType.toString();

    FirebaseCrashlytics.instance.log('💥 [BLoC Error Occurred] in $blocName');

    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: 'Unhandled exception inside $blocName',
      fatal: false,
    );
  }
}
