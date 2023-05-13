import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/function_id_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class CurrentIncomingDataSourcePackage
    extends DataSourceIncomingPackage<Current>
    with
        IsEventOrBufferRequestOrSubscriptionAnswerRequestTypeMixin,
        IsPeriodicValueStatusFunctionIdMixin {
  CurrentIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<Current> get bytesConverter => const CurrentBytesConverter();

  @override
  bool get validParameterId => parameterId.isCurrent;
}
