import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/empty_body.dart';

class OutgoingBufferRequestPackage extends DataSourceOutgoingPackage {
  OutgoingBufferRequestPackage({
    required super.parameterId,
  }) : super(
          requestType: DataSourceRequestType.bufferRequest,
          bytesConvertible: const EmptyBody(),
        );
}
