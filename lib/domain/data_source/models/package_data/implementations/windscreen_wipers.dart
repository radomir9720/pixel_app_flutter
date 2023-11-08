import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_converter.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/function_id.dart';

class WindscreenWipersBody extends BytesConvertible {
  const WindscreenWipersBody({required this.isOn});

  final bool isOn;

  @override
  BytesConverter<WindscreenWipersBody> get bytesConverter =>
      const WindscreenWipersConverter();

  @override
  List<Object?> get props => [isOn];
}

class WindscreenWipersConverter extends BytesConverter<WindscreenWipersBody> {
  const WindscreenWipersConverter();

  @override
  WindscreenWipersBody fromBytes(List<int> bytes) {
    return WindscreenWipersBody(
      isOn: [bytes[1]].toIntFromUint8 == 0xFF,
    );
  }

  @override
  List<int> toBytes(WindscreenWipersBody model) {
    return [
      FunctionId.okEventId,
      if (model.isOn) 0xFF else 0,
    ];
  }
}
