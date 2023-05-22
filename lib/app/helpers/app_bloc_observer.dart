import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:pixel_app_flutter/app/helpers/crashlytics_helper.dart';
import 'package:pixel_app_flutter/app/helpers/logger_records_buffer.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver({
    required this.recordsBuffer,
  });

  final LoggerRecordsBuffer recordsBuffer;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    recordsBuffer.add(
      LogRecord(
        Level.INFO,
        '${change.currentState} -> ${change.nextState}',
        'BlocChangeState',
      ),
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    CrashlyticsHelper.recordError(error, stackTrace);
    recordsBuffer.add(
      LogRecord(
        Level.SEVERE,
        '$error\nStackTrace:\n$stackTrace',
        'BlocError',
      ),
    );
  }
}
