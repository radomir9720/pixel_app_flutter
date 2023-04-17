import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/periodic_value_status.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

class ChargingScreenListTile extends StatelessWidget {
  const ChargingScreenListTile({
    super.key,
    required this.title,
    required this.trailing,
    required this.status,
  });

  @protected
  final String title;

  @protected
  final String trailing;

  @protected
  final PeriodicValueStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: Text(
            trailing,
            style: TextStyle(
              color: context.colorFromStatus(status),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

extension on BuildContext {
  Color? colorFromStatus(PeriodicValueStatus status) {
    return status.when(
      normal: () => null,
      warning: () => AppColors.of(this).warning,
      critical: () => AppColors.of(this).error,
    );
  }
}
