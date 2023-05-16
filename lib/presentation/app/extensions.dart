import 'package:flutter/widgets.dart';
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
