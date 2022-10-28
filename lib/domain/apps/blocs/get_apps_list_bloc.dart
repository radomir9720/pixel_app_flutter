import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'get_apps_list_bloc.freezed.dart';

@freezed
class GetAppsListEvent with _$GetAppsListEvent {
  const factory GetAppsListEvent.loadAppsList() = _LoadAppsList;
}

typedef GetAppsListState = AsyncData<List<ApplicationInfo>, Object>;

class GetAppsListBloc extends Bloc<GetAppsListEvent, GetAppsListState> {
  GetAppsListBloc({required this.appsService})
      : super(const GetAppsListState.initial([])) {
    on<_LoadAppsList>(_loadAppsList);
  }

  @protected
  final AppsService appsService;

  Future<void> _loadAppsList(
    GetAppsListEvent event,
    Emitter<GetAppsListState> emit,
  ) async {
    emit(state.inLoading());

    try {
      final res = await appsService.getAppsList();

      emit(
        res.when(
          error: state.inFailure,
          value: AsyncData.success,
        ),
      );
    } catch (e) {
      emit(state.inFailure());

      rethrow;
    }
  }
}
