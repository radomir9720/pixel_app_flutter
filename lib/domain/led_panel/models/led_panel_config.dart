import 'package:freezed_annotation/freezed_annotation.dart';

part 'led_panel_config.freezed.dart';
part 'led_panel_config.g.dart';

@freezed
class LEDPanelConfig with _$LEDPanelConfig {
  const factory LEDPanelConfig.autoShutdown({
    required int id,
    required int fileId,
    required String name,
    required int shutdownTimeMillis,
  }) = _AutoShutdown;
  const factory LEDPanelConfig.manualShutdown({
    required int id,
    required int fileId,
    required String name,
  }) = _ManualShutdown;

  factory LEDPanelConfig.fromJson(Map<String, dynamic> json) =>
      _$LEDPanelConfigFromJson(json);
}
