import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/set_value.dart';

class OutgoingSetValuePackage extends DataSourceOutgoingPackage {
  OutgoingSetValuePackage({
    required super.parameterId,
    required SetValueBody setValueBody,
  }) : super(
          requestType: DataSourceRequestType.event,
          bytesConvertible: setValueBody,
        );
}
