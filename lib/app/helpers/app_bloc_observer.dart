import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/app/helpers/crashlytics_helper.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver({
    this.onStateChange,
    this.onErrorOcurred,
  });

  final void Function(Change<dynamic> change)? onStateChange;

  final void Function(Object error, StackTrace stackTrace)? onErrorOcurred;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    onStateChange?.call(change);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    CrashlyticsHelper.recordError(error, stackTrace);
    onErrorOcurred?.call(error, stackTrace);
  }
}
