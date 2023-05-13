import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/function_id_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class VoltageIncomingDataSourcePackage
    extends DataSourceIncomingPackage<Voltage>
    with
        IsEventOrBufferRequestOrSubscriptionAnswerRequestTypeMixin,
        IsPeriodicValueStatusFunctionIdMixin {
  VoltageIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<Voltage> get bytesConverter => const VoltageBytesConverter();

  @override
  bool get validParameterId => parameterId.isVoltage;
}
