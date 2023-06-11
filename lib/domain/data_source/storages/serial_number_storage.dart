import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

abstract class SerialNumberStorage {
  Future<Result<WriteSerialNumberStorageError, void>> write(
    SerialNumberChain chain,
  );

  Future<Result<ReadSerialNumberStorageError, Optional<SerialNumberChain>>>
      read(String id);

  Future<Result<RemoveSerialNumberStorageError, void>> remove(String id);
}

sealed class SerialNumberStorageError {}

sealed class ReadSerialNumberStorageError implements SerialNumberStorageError {
  const factory ReadSerialNumberStorageError.unknown() =
      _UnknownReadSerialNumberStorageError;
}

sealed class WriteSerialNumberStorageError implements SerialNumberStorageError {
  const factory WriteSerialNumberStorageError.unknown() =
      _UnknownWriteSerialNumberStorageError;
}

sealed class RemoveSerialNumberStorageError
    implements SerialNumberStorageError {
  const factory RemoveSerialNumberStorageError.unknown() =
      _UnknownRemoveSerialNumberStorageError;
}

final class _UnknownReadSerialNumberStorageError
    implements ReadSerialNumberStorageError {
  const _UnknownReadSerialNumberStorageError();
}

final class _UnknownWriteSerialNumberStorageError
    implements WriteSerialNumberStorageError {
  const _UnknownWriteSerialNumberStorageError();
}

final class _UnknownRemoveSerialNumberStorageError
    implements RemoveSerialNumberStorageError {
  const _UnknownRemoveSerialNumberStorageError();
}
