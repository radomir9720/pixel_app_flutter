import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

extension PeriodicStatusExtension on BuildContext {
  Color? colorFromStatus(
    PeriodicValueStatus status, {
    Color? Function()? onNormal,
  }) {
    return status.when(
      normal: () => onNormal?.call(),
      warning: () => colors.warning,
      critical: () => colors.errorPastel,
    );
  }
}

extension VersionAndBuildNumberExtension on PackageInfo {
  String get versionAndBuildNumber => '$version+$buildNumber';
}

extension FlexSizeExtension on num {
  double flexSize({
    required (double, double) screenFlexRange,
    required (double, double) valueClampRange,
  }) {
    assert(
      screenFlexRange.$1 < screenFlexRange.$2,
      'Min. parameter of flex range should be less than max. parameter',
    );
    final screenMin = screenFlexRange.$1;
    final minValue = valueClampRange.$1;
    if (this < screenMin) return minValue;
    final rangeMax = screenFlexRange.$2;
    final maxValue = valueClampRange.$2;
    if (this > rangeMax) return maxValue;
    final factor = (this - screenMin) / (rangeMax - screenMin);

    final value =
        (minValue + ((maxValue - minValue) * factor)).clamp(minValue, maxValue);
    return value;
  }
}
