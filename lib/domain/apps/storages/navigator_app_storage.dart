import 'package:re_seedwork/re_seedwork.dart';

abstract interface class NavigatorAppStorage {
  Future<Result<SaveNavigatorAppStorageError, void>> save(String package);

  Future<Result<ReadNavigatorAppStorageError, String?>> read();

  Future<Result<SetFastAccessNavigatorAppStorageError, void>> setFastAccess({
    required bool value,
  });

  Future<Result<GetFastAccessNavigatorAppStorageError, bool?>> getFastAccess();
}

sealed class NavigatorAppStorageError {}

sealed class SaveNavigatorAppStorageError implements NavigatorAppStorageError {
  const factory SaveNavigatorAppStorageError.unknown() =
      _UnknownSaveNavigatorAppStorageError;
}

sealed class ReadNavigatorAppStorageError implements NavigatorAppStorageError {
  const factory ReadNavigatorAppStorageError.unknown() =
      _UnknownReadNavigatorAppStorageError;
}

final class _UnknownSaveNavigatorAppStorageError
    implements SaveNavigatorAppStorageError {
  const _UnknownSaveNavigatorAppStorageError();
}

final class _UnknownReadNavigatorAppStorageError
    implements ReadNavigatorAppStorageError {
  const _UnknownReadNavigatorAppStorageError();
}

//
sealed class FastAccessNavigatorAppStorageError {}

sealed class SetFastAccessNavigatorAppStorageError
    extends FastAccessNavigatorAppStorageError {
  const factory SetFastAccessNavigatorAppStorageError.unknown() =
      _UnknownSetFastAccessNavigatorAppStorageError;
}

final class _UnknownSetFastAccessNavigatorAppStorageError
    implements SetFastAccessNavigatorAppStorageError {
  const _UnknownSetFastAccessNavigatorAppStorageError();
}

sealed class GetFastAccessNavigatorAppStorageError
    implements FastAccessNavigatorAppStorageError {
  const factory GetFastAccessNavigatorAppStorageError.unknown() =
      _UnknownGetFastAccessNavigatorAppStorageError;
}

final class _UnknownGetFastAccessNavigatorAppStorageError
    implements GetFastAccessNavigatorAppStorageError {
  const _UnknownGetFastAccessNavigatorAppStorageError();
}
