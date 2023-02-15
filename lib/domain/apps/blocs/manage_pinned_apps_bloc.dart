import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'manage_pinned_apps_bloc.freezed.dart';

@freezed
class ManagePinnedAppsEvent extends EffectEvent with _$ManagePinnedAppsEvent {
  const factory ManagePinnedAppsEvent.add(ApplicationInfo app) = _Add;
  const factory ManagePinnedAppsEvent.remove(ApplicationInfo app) = _Remove;
}

enum ManagePinnedAppsType {
  add,
  remove;

  T when<T>({
    required T Function() add,
    required T Function() remove,
  }) {
    switch (this) {
      case ManagePinnedAppsType.add:
        return add();
      case ManagePinnedAppsType.remove:
        return remove();
    }
  }
}

class ManagePinnedAppsError {
  const ManagePinnedAppsError({
    required this.type,
    required this.appName,
  });

  const ManagePinnedAppsError.add(this.appName)
      : type = ManagePinnedAppsType.add;

  const ManagePinnedAppsError.remove(this.appName)
      : type = ManagePinnedAppsType.remove;

  final ManagePinnedAppsType type;
  final String? appName;
}

@freezed
class ManagePinnedAppsState with _$ManagePinnedAppsState {
  const factory ManagePinnedAppsState.initial() = _Initial;
  const factory ManagePinnedAppsState.loading() = _Loading;
  const factory ManagePinnedAppsState.success(ApplicationInfo app) = _Success;
  const factory ManagePinnedAppsState.failure(ManagePinnedAppsError error) =
      _Failure;
}

class ManagePinnedAppsBloc
    extends Bloc<ManagePinnedAppsEvent, ManagePinnedAppsState>
    with BlocEventHandlerMixin {
  ManagePinnedAppsBloc({required this.pinnedAppsStorage})
      : super(const ManagePinnedAppsState.initial()) {
    on<_Add>(
      (event, emit) {
        final failureState = ManagePinnedAppsState.failure(
          ManagePinnedAppsError.add(event.app.name),
        );
        return handle<Result<ErrorWritingPinnedAppsStorage, Set<String>>>(
          event: event,
          emit: emit,
          inLoading: (_) => const ManagePinnedAppsState.loading(),
          inFailure: (_) => failureState,
          action: () async {
            final packageName = event.app.packageName;
            if (packageName == null) {
              return const Result.error(
                ErrorWritingPinnedAppsStorage.packageNameIsNull,
              );
            }
            return pinnedAppsStorage.write(packageName);
          },
          onActionResult: (actionResult) async {
            return actionResult.when(
              error: (e) => failureState,
              value: (_) => ManagePinnedAppsState.success(
                event.app.copyWith(pinned: true),
              ),
            );
          },
        );
      },
    );
    on<_Remove>(
      (event, emit) {
        final failureState = ManagePinnedAppsState.failure(
          ManagePinnedAppsError.remove(event.app.name),
        );
        return handle<Result<ErrorRemovingPinnedAppsStorage, Set<String>>>(
          event: event,
          emit: emit,
          inLoading: (_) => const ManagePinnedAppsState.loading(),
          inFailure: (_) => failureState,
          action: () async {
            final packageName = event.app.packageName;
            if (packageName == null) {
              return const Result.error(
                ErrorRemovingPinnedAppsStorage.packageNameIsNull,
              );
            }

            return pinnedAppsStorage.remove([packageName]);
          },
          onActionResult: (actionResult) async {
            return actionResult.when(
              error: (e) => failureState,
              value: (_) => ManagePinnedAppsState.success(
                event.app.copyWith(pinned: false),
              ),
            );
          },
        );
      },
    );
  }

  @protected
  final PinnedAppsStorage pinnedAppsStorage;
}
