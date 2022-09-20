import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.title,
  });

  @protected
  final VoidCallback? onPressed;

  @protected
  final IconData icon;

  @protected
  final String title;

  @protected
  static const borderRadius = BorderRadius.all(Radius.circular(8));

  @protected
  static const buttonColor = Color(0x0AF0F0F0);

  @protected
  static const titleStyle = TextStyle(
    fontSize: 16,
    height: 1.18,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(
          color: AppColors.of(context).border,
        ),
        color: buttonColor,
      ),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    title,
                    style:
                        titleStyle.copyWith(color: AppColors.of(context).text),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
