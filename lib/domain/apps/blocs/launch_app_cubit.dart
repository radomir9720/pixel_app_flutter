import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:re_seedwork/re_seedwork.dart';

typedef LaunchAppState = AsyncData<String?, Object>;

class LaunchAppCubit extends Cubit<LaunchAppState> {
  LaunchAppCubit({required this.appsService})
      : super(const AsyncData.initial(null));

  @protected
  final AppsService appsService;

  Future<void> launchApp(String packageName) async {
    emit(AsyncData.loading(packageName));

    try {
      final res = await appsService.startApp(packageName);

      emit(
        res.when(
          error: state.inFailure,
          value: (v) => state.inSuccess(),
        ),
      );
    } catch (e) {
      emit(state.inFailure());

      rethrow;
    }
  }
}
