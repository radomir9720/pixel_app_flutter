import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/function_id.dart';

enum PeriodicValueStatus {
  normal(FunctionId.okIncomingPeriodicValueId),
  warning(FunctionId.warningIncomingPeriodicValueId),
  critical(FunctionId.criticalIncomingPeriodicValueId);

  const PeriodicValueStatus(this.id);

  final int id;

  static PeriodicValueStatus fromId(int id) {
    return PeriodicValueStatus.values.firstWhere((element) => element.id == id);
  }

  static bool isValid(int value) {
    return values.any((element) => element.id == value);
  }

  List<int> get toBytes => id.toBytesInt8;

  T when<T>({
    required T Function() normal,
    required T Function() warning,
    required T Function() critical,
  }) {
    switch (this) {
      case PeriodicValueStatus.normal:
        return normal();
      case PeriodicValueStatus.warning:
        return warning();
      case PeriodicValueStatus.critical:
        return critical();
    }
  }
}
