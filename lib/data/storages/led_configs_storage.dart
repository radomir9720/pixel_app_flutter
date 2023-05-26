import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/led_panel/led_panel.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: LEDConfigsStorage)
final class LEDConfigsStorageImpl
    extends InMemoryValueStore<List<LEDPanelConfig>>
    implements LEDConfigsStorage {
  LEDConfigsStorageImpl({required this.prefs}) : super([]);

  @protected
  final SharedPreferences prefs;

  @visibleForTesting
  static const kLedConfigsKey = 'LEDConfigs';

  @override
  Future<Result<ReadLEDConfigsStorageError, List<LEDPanelConfig>>>
      read() async {
    final value = prefs.getStringList(kLedConfigsKey);
    final result = [
      ...?value?.map(
        (e) => LEDPanelConfig.fromJson(jsonDecode(e) as Map<String, dynamic>),
      )
    ];
    await put(result);
    return Result.value(result);
  }

  @override
  Future<Result<WriteLEDConfigsStorageError, void>> write(
    List<LEDPanelConfig> configs,
  ) async {
    final stringList = configs.map((e) => jsonEncode(e.toJson())).toList();
    final success = await prefs.setStringList(kLedConfigsKey, stringList);
    if (success) {
      await put(configs);
      return const Result.value(null);
    }

    return const Result.error(WriteLEDConfigsStorageError.unknown);
  }
}
