import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/data/exceptions/store_exception.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: UserDefinedButtonsStorage)
class UserDefinedButtonsStorageImpl
    extends InMemoryValueStore<UnmodifiableListView<UserDefinedButton>>
    implements UserDefinedButtonsStorage {
  UserDefinedButtonsStorageImpl({
    required this.prefs,
    required this.serializers,
  })  : _initialized = false,
        super(UnmodifiableListView(const []));

  @protected
  final SharedPreferences prefs;

  @protected
  final List<UserDefinedButtonSerializer> serializers;

  @visibleForTesting
  static const kButtonsKey = 'userDefinedButtons';

  bool _initialized;

  bool get initialized => _initialized;

  @override
  Future<Result<DeleteByIdUserDefinedButtonsStorageError, void>> deleteById(
    int id,
  ) async {
    final newData = data.where((element) => element.id != id);
    final success =
        await prefs.setString(kButtonsKey, jsonEncode(newData.toMap()));
    if (success) {
      await put(UnmodifiableListView(newData));
      return const Result.value(null);
    }

    throw const StoreException.write();
  }

  @override
  Future<Result<WriteUserDefinedButtonsStorageError, void>> append(
    UserDefinedButton button,
  ) async {
    final newData = [...data, button];
    final success =
        await prefs.setString(kButtonsKey, jsonEncode(newData.toMap()));
    if (success) {
      await put(UnmodifiableListView(newData));
      return const Result.value(null);
    }

    throw const StoreException.write();
  }

  @override
  Future<Result<ReadUserDefinedButtonsStorageError, List<UserDefinedButton>>>
      read() async {
    if (initialized) return Result.value(data);
    final raw = prefs.getString(kButtonsKey);
    if (raw == null) {
      _initialized = true;
      await put(UnmodifiableListView([]));
      return const Result.value([]);
    }
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    final buttonsByKey = groupBy(list, (item) => item.parseKey);
    final serializersByKey = groupBy(serializers, (ser) => ser.key);

    final buttons = <UserDefinedButton>[];

    for (final entry in buttonsByKey.entries) {
      final key = entry.key;
      final serializer = serializersByKey[key]
          .checkNotNull('Serializer for key "$key" not found!')
          .first;
      buttons.addAll(entry.value.map(serializer.fromMap));
    }
    await put(UnmodifiableListView(buttons));

    _initialized = true;

    return Result.value(buttons);
  }
}

extension on Iterable<UserDefinedButton> {
  List<Map<String, dynamic>> toMap() {
    return map((e) => e.toMap).toList();
  }
}
