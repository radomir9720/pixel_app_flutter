import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class SpeedIncomingDataSourcePackage extends DataSourceIncomingPackage<Speed>
    with IsValueUpdateOrBufferRequestOrSubscriptionAnswerMixin {
  SpeedIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<Speed> get dataBytesToModelConverter => const SpeedConverter();

  @override
  bool get validParameterId => parameterId.isSpeed;
}
