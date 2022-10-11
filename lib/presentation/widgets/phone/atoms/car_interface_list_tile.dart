import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

enum CarInterfaceState {
  primary,
  success,
  error;

  R when<R>({
    required R Function() primary,
    required R Function() success,
    required R Function() error,
  }) {
    switch (this) {
      case CarInterfaceState.error:
        return error();
      case CarInterfaceState.primary:
        return primary();
      case CarInterfaceState.success:
        return success();
    }
  }
}

class CarInterfaceListTile extends StatelessWidget {
  const CarInterfaceListTile({
    super.key,
    required this.title,
    required this.status,
    required this.icon,
    required this.state,
    this.onPressed,
  });

  @protected
  final String title;

  @protected
  final String status;

  @protected
  final IconData icon;

  @protected
  final CarInterfaceState state;

  @protected
  final VoidCallback? onPressed;

  @protected
  static const textStyle = TextStyle(
    fontSize: 15,
    height: 1.21,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final statusColor = state.when(
      error: () => colors.errorPastel,
      primary: () => colors.primaryPastel,
      success: () => colors.successPastel,
    );

    return ListTile(
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: title),
            const TextSpan(text: ' ['),
            TextSpan(
              text: status,
              style: textStyle.copyWith(color: statusColor),
            ),
            const TextSpan(text: ']'),
          ],
          style: textStyle.copyWith(color: AppColors.of(context).text),
        ),
      ),
      onTap: onPressed,
      shape: Border(
        bottom: BorderSide(
          color: AppColors.of(context).border,
        ),
      ),
      contentPadding: const EdgeInsets.only(left: 4),
      trailing: Icon(
        icon,
        size: 23,
        color: colors.text,
      ),
    );
  }
}
