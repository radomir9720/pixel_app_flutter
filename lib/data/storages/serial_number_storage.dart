import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

@Injectable(as: SerialNumberStorage)
final class SerialNumberStorageImpl implements SerialNumberStorage {
  const SerialNumberStorageImpl({required this.secureStorage});

  @protected
  final FlutterSecureStorage secureStorage;

  @visibleForTesting
  static const kSerialNumberKey = 'DataSourceSerialNumber';

  @visibleForTesting
  String generateKey(String id) => '${kSerialNumberKey}_$id';

  @override
  Future<Result<ReadSerialNumberStorageError, Optional<SerialNumberChain>>>
      read(String id) async {
    // await secureStorage.deleteAll();
    final response = await secureStorage.read(key: generateKey(id));
    if (response == null) {
      const value = Optional<SerialNumberChain>.undefined();

      return const Result.value(value);
    }
    final chain = SerialNumberChain.fromJson(response);
    final value = Optional.presented(chain);

    return Result.value(value);
  }

  @override
  Future<Result<WriteSerialNumberStorageError, void>> write(
    SerialNumberChain chain,
  ) async {
    await secureStorage.write(
      key: generateKey(chain.id),
      value: chain.toJson(),
    );
    return const Result.value(null);
  }

  @override
  Future<Result<RemoveSerialNumberStorageError, void>> remove(String id) async {
    await secureStorage.delete(key: kSerialNumberKey);
    return const Result.value(null);
  }
}
