import 'package:re_seedwork/re_seedwork.dart';

abstract class AlwaysOnDisplayStorage {
  const AlwaysOnDisplayStorage();

  Future<Result<AlwaysOnDisplayStorageWriteError, void>> write({
    required bool enable,
  });

  Future<Result<AlwaysOnDisplayStorageRemoveError, void>> remove();

  Result<AlwaysOnDisplayStorageReadError, bool> read();
}

enum AlwaysOnDisplayStorageWriteError { unknown }

enum AlwaysOnDisplayStorageRemoveError { unknown }

enum AlwaysOnDisplayStorageReadError { unknown, noValue }
