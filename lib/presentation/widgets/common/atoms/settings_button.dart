import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

enum SettingsButtonState {
  error,
  enabled,
  selected;

  R when<R>({
    required R Function() error,
    required R Function() enabled,
    required R Function() selected,
  }) {
    switch (this) {
      case SettingsButtonState.error:
        return error();
      case SettingsButtonState.enabled:
        return enabled();
      case SettingsButtonState.selected:
        return selected();
    }
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    this.onPressed,
    this.titleFontSize,
    required this.icon,
    required this.title,
    this.state = SettingsButtonState.enabled,
  });

  @protected
  final VoidCallback? onPressed;

  @protected
  final IconData icon;

  @protected
  final String title;

  @protected
  final double? titleFontSize;

  @protected
  final SettingsButtonState state;

  @protected
  static const borderRadius = BorderRadius.all(Radius.circular(8));

  @protected
  static const buttonColor = Color(0x0AF0F0F0);

  @protected
  static const titleStyle = TextStyle(
    fontSize: 16,
    height: 1.42,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(
          color: state.when(
            error: () => AppColors.of(context).errorAccent,
            enabled: () => AppColors.of(context).border,
            selected: () => AppColors.of(context).primary,
          ),
        ),
        color: state.when(
          error: () => AppColors.of(context).errorAccent.withOpacity(.15),
          enabled: () => buttonColor,
          selected: () => AppColors.of(context).primary.withOpacity(.15),
        ),
      ),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(icon),
              ),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: titleStyle.copyWith(
                    color: AppColors.of(context).text,
                    fontSize: titleFontSize ??
                        DefaultTextStyle.of(context).style.fontSize,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
