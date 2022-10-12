import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

class InterfaceButton extends StatelessWidget {
  const InterfaceButton({
    super.key,
    required this.icon,
    required this.bottom,
    this.onPressed,
    this.disabled = false,
  });

  factory InterfaceButton.withTitle({
    required String title,
    required IconData icon,
    VoidCallback? onPressed,
    bool disabled = false,
  }) =>
      InterfaceButton(
        bottom: Text(
          title,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        icon: icon,
        onPressed: onPressed,
        disabled: disabled,
      );

  @protected
  final IconData icon;

  @protected
  final Widget bottom;

  @protected
  final VoidCallback? onPressed;

  @protected
  final bool disabled;

  @protected
  static const textStyle = TextStyle(
    fontSize: 11,
    height: 1.21,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );

  @override
  Widget build(BuildContext context) {
    final color =
        disabled ? AppColors.of(context).disabled : AppColors.of(context).text;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 26,
                color: color,
              ),
              const SizedBox(
                height: 8,
              ),
              DefaultTextStyle(
                style: textStyle.copyWith(
                  color: color,
                ),
                child: bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
