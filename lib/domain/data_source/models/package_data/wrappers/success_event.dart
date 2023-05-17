import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

abstract class SuccessEventBody extends BytesConvertible {
  const SuccessEventBody();

  @override
  BytesConverter<SuccessEventBody> get bytesConverter;
}

abstract class SuccessEventBodyConverter<T extends SuccessEventBody>
    extends BytesConverter<T> {
  const SuccessEventBodyConverter();

  @override
  T fromBytes(List<int> bytes) {
    return dataFromBytes(bytes.sublist(1));
  }

  T dataFromBytes(List<int> bytes);

  List<int> dataToBytes(T model);

  @override
  List<int> toBytes(T model) {
    return [
      FunctionId.okEventId,
      ...dataToBytes(model),
    ];
  }
}
