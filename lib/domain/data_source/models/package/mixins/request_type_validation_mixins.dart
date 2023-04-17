import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_incoming_package.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

mixin IsValueUpdateMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validRequestType => requestType.isValueUpdate;
}

mixin IsValueUpdateOrBufferRequestMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validRequestType =>
      requestType.isValueUpdate || requestType.isBufferRequest;
}

mixin IsValueUpdateOrBufferRequestOrSubscriptionAnswerMixin<
    T extends BytesConvertible> on DataSourceIncomingPackage<T> {
  @override
  bool get validRequestType =>
      requestType.isValueUpdate ||
      requestType.isBufferRequest ||
      requestType.isSubscription;
}
