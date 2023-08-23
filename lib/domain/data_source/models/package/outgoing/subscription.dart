import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/empty_body.dart';

class OutgoingSubscribePackage extends DataSourceOutgoingPackage {
  OutgoingSubscribePackage({
    required super.parameterId,
  }) : super(
          requestType: const DataSourceRequestType.subscription(),
          bytesConvertible: const EmptyBody(),
        );
}

class OutgoingUnsubscribePackage extends DataSourceOutgoingPackage {
  OutgoingUnsubscribePackage({
    required DataSourceParameterId parameterId,
  }) : super(
          requestType: const DataSourceRequestType.subscription(),
          bytesConvertible: const EmptyBody(),
          parameterId: modifyId(parameterId),
        );

  static DataSourceParameterId modifyId(DataSourceParameterId initial) {
    return DataSourceParameterId.custom(initial.value + kOperand);
  }

  static const kOperand = 0x8000;
}
