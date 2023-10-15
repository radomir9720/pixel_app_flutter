import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_converter.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/function_id.dart';

class DoorBody extends BytesConvertible {
  const DoorBody({required this.isOpen});

  final bool isOpen;

  @override
  BytesConverter<DoorBody> get bytesConverter => const DoorBodyConverter();

  @override
  List<Object?> get props => [isOpen];
}

class DoorBodyConverter extends BytesConverter<DoorBody> {
  const DoorBodyConverter();

  @override
  DoorBody fromBytes(List<int> bytes) {
    return DoorBody(
      isOpen: [bytes[1]].toIntFromUint8 == 0xFF,
    );
  }

  @override
  List<int> toBytes(DoorBody model) {
    return [
      FunctionId.okEventId,
      if (model.isOpen) 0xFF else 0,
    ];
  }
}
