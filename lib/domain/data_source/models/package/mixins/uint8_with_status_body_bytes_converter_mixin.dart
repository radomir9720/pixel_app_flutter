import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_package.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

mixin Uint8WithStatusBodyBytesConverterMixin
    on DataSourceIncomingPackage<Uint8WithStatusBody> {
  @override
  BytesConverter<Uint8WithStatusBody> get bytesConverter =>
      Uint8WithStatusBody.converter;
}
