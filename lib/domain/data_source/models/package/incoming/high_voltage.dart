import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/function_id_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class HighVoltageIncomingDataSourcePackage
    extends DataSourceIncomingPackage<HighVoltage>
    with
        IsEventOrBufferRequestOrSubscriptionAnswerRequestTypeMixin,
        IsSuccessEventFunctionIdMixin {
  HighVoltageIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<HighVoltage> get bytesConverter =>
      const HighVoltageConverter();

  @override
  bool get validParameterId => parameterId.isHighVoltage;
}
