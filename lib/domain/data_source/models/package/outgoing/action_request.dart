import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/implementations/action_body.dart';

class OutgoingActionRequestPackage extends DataSourceOutgoingPackage {
  OutgoingActionRequestPackage({
    required super.parameterId,
  }) : super(
          requestType: const DataSourceRequestType.event(),
          bytesConvertible: const ActionBody(),
        );
}
