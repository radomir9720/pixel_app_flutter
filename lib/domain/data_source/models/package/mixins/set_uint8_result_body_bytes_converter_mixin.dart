import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/implementations/set_uint8_body.dart';

mixin SetUint8ResultBodyBytesConverterMixin
    on DataSourceIncomingPackage<SetUint8ResultBody> {
  @override
  BytesConverter<SetUint8ResultBody> get bytesConverter =>
      const SetUint8ResultBodyConverter();
}
