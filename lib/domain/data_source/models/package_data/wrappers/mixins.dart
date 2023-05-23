import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

mixin PeriodicValueStatusOrOkEventFunctionIdMxixn<T extends BytesConvertible>
    on BytesConverter<T> {
  R whenFunctionId<R, Y>({
    required List<int> body,
    required Y Function(List<int> bytes) dataParser,
    required R Function(Y data, PeriodicValueStatus status) status,
    required R Function(
      Y data,
    ) okEvent,
  }) {
    final functionId = body[0];
    final isFunctionId = PeriodicValueStatus.isValid(functionId);
    final data = body.sublist(1);
    final parsed = dataParser(data);

    if (isFunctionId) {
      return status(parsed, PeriodicValueStatus.fromId(functionId));
    }
    return okEvent(parsed);
  }
}
