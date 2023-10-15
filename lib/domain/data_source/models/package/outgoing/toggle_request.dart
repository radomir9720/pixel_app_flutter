import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

class OutgoingToggleRequestPackage extends DataSourceOutgoingPackage {
  OutgoingToggleRequestPackage({
    required super.bytesConvertible,
    required super.parameterId,
  }) : super(requestType: const DataSourceRequestType.event());
}
