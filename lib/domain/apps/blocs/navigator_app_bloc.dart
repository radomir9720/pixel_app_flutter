import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'navigator_app_bloc.freezed.dart';

@freezed
class NavigatorAppEvent extends EffectEvent with _$NavigatorAppEvent {
  const factory NavigatorAppEvent.load() = _Load;
  const factory NavigatorAppEvent.set(String package) = _Set;
}

typedef NavigatorAppState = AsyncData<String?, NavigatorAppStorageError>;

class NavigatorAppBloc extends Bloc<NavigatorAppEvent, NavigatorAppState>
    with BlocEventHandlerMixin {
  NavigatorAppBloc({required this.storage})
      : super(const NavigatorAppState.initial(null)) {
    on<_Load>(
      (event, emit) => handle<Result<ReadNavigatorAppStorageError, String?>>(
        event: event,
        emit: emit,
        inLoading: () => state.inLoading(),
        inFailure: () => state.inFailure(),
        action: storage.read,
        onActionResult: (actionResult) async {
          return actionResult.when(
            error: state.inFailure,
            value: AsyncData.success,
          );
        },
      ),
    );
    on<_Set>(
      (event, emit) => handle<Result<SaveNavigatorAppStorageError, void>>(
        event: event,
        emit: emit,
        inLoading: () => state.inLoading(),
        inFailure: () => state.inFailure(),
        action: () => storage.save(event.package),
        onActionResult: (actionResult) async {
          return actionResult.when(
            error: state.inFailure,
            value: (_) => AsyncData.success(event.package),
          );
        },
      ),
    );
  }

  @protected
  final NavigatorAppStorage storage;
}
