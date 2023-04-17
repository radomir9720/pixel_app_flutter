import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class VoltageIncomingDataSourcePackage
    extends DataSourceIncomingPackage<Voltage>
    with IsValueUpdateOrBufferRequestOrSubscriptionAnswerMixin {
  VoltageIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<Voltage> get dataBytesToModelConverter =>
      const VoltageBytesConverter();

  @override
  bool get validParameterId => parameterId.isVoltage;
}
