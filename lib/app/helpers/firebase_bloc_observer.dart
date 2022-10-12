import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/app/helpers/crashlytics_helper.dart';

class FirebaseBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    CrashlyticsHelper.recordError(error, stackTrace);
  }
}
