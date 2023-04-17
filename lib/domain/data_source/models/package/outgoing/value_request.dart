import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class OutgoingValueRequestPackage extends DataSourceOutgoingPackage {
  OutgoingValueRequestPackage({
    required super.parameterId,
  }) : super(
          requestType: DataSourceRequestType.valueUpdate,
          bytesConvertible: const RequestValueBody(),
        );
}
