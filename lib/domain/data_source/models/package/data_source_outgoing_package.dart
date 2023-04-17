import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class DataSourceOutgoingPackage extends DataSourcePackage {
  DataSourceOutgoingPackage({
    required DataSourceRequestType requestType,
    required BytesConvertible bytesConvertible,
    required DataSourceParameterId parameterId,
  }) : super.fromBody([
          0x00, // First config byte
          requestType.value, // second config byte. Request type
          ...parameterId.value.toBytesUint16,
          bytesConvertible.toBytes.length,
          ...bytesConvertible.toBytes,
        ]);
}
