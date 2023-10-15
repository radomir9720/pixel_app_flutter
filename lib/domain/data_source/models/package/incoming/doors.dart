import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/function_id_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/function_id.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/implementations/doors.dart';

abstract class DoorIncomingDataSourcePackage
    extends DataSourceIncomingPackage<DoorBody>
    with IsSuccessEventFunctionIdMixin, IsEventRequestTypeMixin {
  DoorIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<DoorBody> get bytesConverter => const DoorBodyConverter();
}

final class LeftDoorIncomingDataSourcePackage
    extends DoorIncomingDataSourcePackage {
  LeftDoorIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.value == ButtonFunctionId.leftDoorId;
}

final class RightDoorIncomingDataSourcePackage
    extends DoorIncomingDataSourcePackage {
  RightDoorIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId =>
      parameterId.value == ButtonFunctionId.rightDoorId;
}
