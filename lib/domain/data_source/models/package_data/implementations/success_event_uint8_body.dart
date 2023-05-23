import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_converter.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/success_event.dart';

class SuccessEventUint8Body extends SuccessEventBody {
  const SuccessEventUint8Body(this.value);

  final int value;

  @override
  BytesConverter<SuccessEventUint8Body> get bytesConverter =>
      const SuccessEventUint8BodyConverter();

  @override
  List<Object?> get props => [value];
}

class SuccessEventUint8BodyConverter
    extends SuccessEventBodyConverter<SuccessEventUint8Body> {
  const SuccessEventUint8BodyConverter();

  @override
  SuccessEventUint8Body dataFromBytes(List<int> bytes) {
    return SuccessEventUint8Body(bytes.toIntFromUint8);
  }

  @override
  List<int> dataToBytes(SuccessEventUint8Body model) {
    return model.value.toBytesUint8;
  }
}
