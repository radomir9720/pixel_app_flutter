import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/implementations/request_value_body.dart';

class OutgoingValueRequestPackage extends DataSourceOutgoingPackage {
  OutgoingValueRequestPackage({
    required super.parameterId,
  }) : super(
          requestType: DataSourceRequestType.event,
          bytesConvertible: const RequestValueBody(),
        );
}
