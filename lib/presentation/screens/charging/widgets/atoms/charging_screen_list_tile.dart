import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/periodic_value_status.dart';
import 'package:pixel_app_flutter/presentation/app/extensions.dart';

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
    return ListTile(
      title: Text(title),
      trailing: Text(
        trailing,
        style: TextStyle(
          color: context.colorFromStatus(status),
        ),
      ),
    );
  }
}
