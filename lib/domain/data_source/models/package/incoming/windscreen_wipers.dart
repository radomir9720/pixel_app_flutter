import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/function_id_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class WindscreenWipersIncomingDataSourcePackage
    extends DataSourceIncomingPackage<WindscreenWipersBody>
    with IsSuccessEventFunctionIdMixin, IsEventRequestTypeMixin {
  WindscreenWipersIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<WindscreenWipersBody> get bytesConverter =>
      const WindscreenWipersConverter();

  @override
  bool get validParameterId =>
      parameterId == const DataSourceParameterId.windscreenWipers();
}
