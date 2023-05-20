import 'package:re_seedwork/re_seedwork.dart';

abstract interface class OverlayStorage {
  Future<Result<SetEnabledStorageError, void>> setEnabled({
    required bool value,
  });

  Future<Result<ReadEnabledStorageError, bool?>> readEnabled();
}

sealed class OverlayStorageError {}

sealed class SetEnabledStorageError implements OverlayStorageError {
  const factory SetEnabledStorageError.unknown() =
      _UnknownSetEnabledStorageError;
}

class _UnknownSetEnabledStorageError implements SetEnabledStorageError {
  const _UnknownSetEnabledStorageError();
}

sealed class ReadEnabledStorageError implements OverlayStorageError {
  const factory ReadEnabledStorageError.unknown() =
      _UnknownReadEnabledStorageError;
}

class _UnknownReadEnabledStorageError implements ReadEnabledStorageError {
  const _UnknownReadEnabledStorageError();
}
