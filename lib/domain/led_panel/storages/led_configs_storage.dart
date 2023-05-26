import 'package:pixel_app_flutter/domain/led_panel/led_panel.dart';
import 'package:re_seedwork/re_seedwork.dart';

abstract interface class LEDConfigsStorage
    extends ValueStore<List<LEDPanelConfig>> {
  Future<Result<WriteLEDConfigsStorageError, void>> write(
    List<LEDPanelConfig> configs,
  );

  Future<Result<ReadLEDConfigsStorageError, List<LEDPanelConfig>>> read();
}

enum ReadLEDConfigsStorageError { unknown }

enum WriteLEDConfigsStorageError { unknown }
