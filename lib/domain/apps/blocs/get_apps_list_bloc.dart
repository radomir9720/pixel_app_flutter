import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'get_apps_list_bloc.freezed.dart';

@freezed
class GetAppsListEvent extends EffectEvent with _$GetAppsListEvent {
  const factory GetAppsListEvent.loadAppsList() = _LoadAppsList;
}

typedef GetAppsListState = AsyncData<ApplicationsEntity, Object>;

class GetAppsListBloc extends Bloc<GetAppsListEvent, GetAppsListState>
    with BlocEventHandlerMixin {
  GetAppsListBloc({
    required this.appsService,
    required this.pinnedAppsStorage,
  }) : super(GetAppsListState.initial(ApplicationsEntity.empty())) {
    on<_LoadAppsList>(
      (event, emit) =>
          handle<Result<GetAppsListAppServiceError, List<ApplicationInfo>>>(
        event: event,
        emit: emit,
        inLoading: () => state.inLoading(),
        inFailure: () => state.inFailure(),
        action: appsService.getAppsList,
        onActionResult: (actionResult) async {
          return actionResult.when(
            error: state.inFailure,
            value: (value) {
              final pinned = pinnedAppsStorage.data.toList();

              return AsyncData.success(
                ApplicationsEntity(value).markPinned(pinned).sorted,
              );
            },
          );
        },
      ),
    );
  }

  @protected
  final AppsService appsService;

  @protected
  final PinnedAppsStorage pinnedAppsStorage;
}
