import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_incoming_package.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

mixin IsEventRequestTypeMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validRequestType => requestType.isEvent;
}

mixin IsEventOrBufferRequestRequestTypeMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validRequestType =>
      requestType.isEvent || requestType.isBufferRequest;
}

mixin IsEventOrBufferRequestOrSubscriptionAnswerRequestTypeMixin<
    T extends BytesConvertible> on DataSourceIncomingPackage<T> {
  @override
  bool get validRequestType =>
      requestType.isEvent ||
      requestType.isBufferRequest ||
      requestType.isSubscription;
}

mixin IsEventOrSubscriptionAnswerRequestTypeMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validRequestType =>
      requestType.isEvent || requestType.isSubscription;
}
